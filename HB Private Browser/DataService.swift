import CryptoKit
import Foundation
import KeychainSwift

class DataService {
    static let shared = DataService()
    
    private let keychain = KeychainSwift()
    private let keychainKey = "secretKey"
    
    private var key: SymmetricKey {
        if let keyData = keychain.getData(keychainKey) {
            return SymmetricKey(data: keyData)
        } else {
            let key = SymmetricKey(size: .bits256)
            let keyData = Data(key.withUnsafeBytes { Data($0) })
            keychain.set(keyData, forKey: keychainKey)
            return key
        }
    }
    
    enum DataServiceError: Error {
        case decryptionError
        case encryptionError
        case dataNotFound
    }
    
    func encryptData(_ data: Data) throws -> Data {
        let sealedBox = try ChaChaPoly.seal(data, using: self.key)
        return sealedBox.combined
    }
    
    func decryptData(_ encryptedData: Data) throws -> Data {
        let sealedBox = try ChaChaPoly.SealedBox(combined: encryptedData)
        let originalData = try ChaChaPoly.open(sealedBox, using: self.key)
        return originalData
    }
    
    func saveData(_ data: Data, for key: String) throws {
        let encryptedData = try encryptData(data)
        keychain.set(encryptedData, forKey: key)
    }
    
    func loadData(for key: String) throws -> Data {
        guard let encryptedData = keychain.getData(key) else {
            throw DataServiceError.dataNotFound
        }
        
        do {
            let decryptedData = try decryptData(encryptedData)
            return decryptedData
        } catch {
            throw DataServiceError.decryptionError
        }
    }
    
    func saveData(_ data: Data, metadata: [String: Any]? = nil, for key: String) throws {
        var encryptedData = try encryptData(data)
        
        if let metadata = metadata {
            let archivedMetadata = try NSKeyedArchiver.archivedData(withRootObject: metadata, requiringSecureCoding: true)
            encryptedData.append(archivedMetadata)
        }
        
        keychain.set(encryptedData, forKey: key)
    }
    
    func loadData(withMetadata: Bool = false, for key: String) throws -> (Data, [String: Any]?) {
        guard let encryptedData = keychain.getData(key) else {
            throw DataServiceError.dataNotFound
        }
        
        var decryptedData: Data
        var metadata: [String: Any]?
        
        do {
            let sealedBox = try ChaChaPoly.SealedBox(combined: encryptedData)
            decryptedData = try ChaChaPoly.open(sealedBox, using: self.key)
            
            if withMetadata {
                let startIndex = sealedBox.combined.count
                let metadataData = sealedBox.combined[startIndex...]
                metadata = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSDictionary.self, NSString.self], from: metadataData) as? [String: Any]
            }
        } catch {
            throw DataServiceError.decryptionError
        }
        
        return (decryptedData, metadata)
    }
}
