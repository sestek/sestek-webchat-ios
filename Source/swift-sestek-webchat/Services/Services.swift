//
//  Services.swift
//  swift-sestek-webchat
//
//  Created by Ömer Sezer on 12.12.2022.
//

import Alamofire

final class Services {
    static let shared = Services()
    private let sessionManager: SessionManager
    
    init() {
        self.sessionManager = SessionManager()
    }
    
    func uploadVoice(recordedFileURL: URL?, sessionId: String?, project: String?, clientId: String?, tenant: String?, fullName: String?, customAction: String?, customActionData: String?, onSoundUploaded: @escaping ((_ jsonObject: String?) -> Void), onError: @escaping ((_ error: String?) -> Void)) {
        guard let url = URL(string: "https://nd-test-webchat.sestek.com/Home/SendAudio") else { return }
        let parameters: [String: String] = [
            "user": sessionId ?? "",
            "project": project ?? "",
            "clientId": clientId ?? "",
            "tenant": tenant ?? "",
            "fullName": fullName ?? "",
            "customAction": customAction ?? "",
            "customActionData": customActionData ?? ""
        ]
        guard let recordedFileURL = recordedFileURL,
              let sound = try? Data(contentsOf: recordedFileURL) else { return }
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        let stringData = String(data: jsonData ?? Data(), encoding: String.Encoding.utf8)
        sessionManager.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(sound, withName: "file_contents", fileName: "\(UUID().uuidString).m4a", mimeType: "audio/mp4")
            for param in parameters {
                multipartFormData.append(param.value.data(using: String.Encoding.utf8)!, withName: param.key)
            }
        }, usingThreshold: UInt64.init(), to: url, method: .post) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    switch response.result {
                    case .success(let json):
                        print(json)
                        onSoundUploaded(stringData)
                    case .failure(let error):
                        onError(error.localizedDescription)
                    }
                }
                print(upload)
            case .failure(let encodingError):
                onError(encodingError.localizedDescription)
            }
        }
    }
}
