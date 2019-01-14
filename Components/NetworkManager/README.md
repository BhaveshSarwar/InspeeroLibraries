# Network Manager

Network manager is wrapper based on the Alamofire

## Installation

```bash
pod 'InspeeroLibs/NetworkManager'
```

## Usage

```swift
import InspeeroLibs

// 
// 1. Global server URL
// 2. Server URL Seperate in each API 
// 3. Image Upload
//

// Global server URL 
ILNetworkManager.shared.serverURL = "https://vps3.inspeero.com:2020/api"
ILNetworkManager.shared.sendRequest(methodType: .post,
apiName: "Login",
parameters: parameters, headers: nil) { (response, error) in
if response != nil && error == nil{
print("Response received")
}else{
print("Error Occured")
}
}

// Seperate Server URL 
ILNetworkManager.shared.sendRequest(baseUrl: "https://vps3.inspeero.com:2020/api"
methodType: .post,
apiName: "Login",
parameters: parameters, headers: nil) { (response, error) in
if response != nil && error == nil{
print("Response received")
}else{
print("Error Occured")
}
}

// Upload images
ILNetworkManager.shared.sendRequest(methodType: .post,
apiName: "Login",
images: images, // Images array that you want to upload
parameters: parameters, headers: nil) { (response, error) in
if response != nil && error == nil{
print("Response received")
}else{
print("Error Occured")
}
}


```
## License
[MIT](https://choosealicense.com/licenses/mit/)
