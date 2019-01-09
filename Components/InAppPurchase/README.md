# InAppPurchase
## Installation

```bash
pod 'InspeeroLibs/InAppPurchase'
```

## Usage

```swift
import InAppHelper_Swift


// Fetch Al products with Given product id's
let store = IAPHelper(productIds: ["produtID1","productID2"])
store.requestProducts { (isProductFetched, products) in
print(products)
}

// For receive purchase Call back first you have to observe the following notification
NotificationCenter.default.addObserver(self, selector: #selector(MasterViewController.handlePurchaseNotification(_:)),
name: .IAPHelperPurchaseNotification,
object: nil)

//Purchase product
store.buyProduct(product) // products should be the SKProduct object


// Restore purchases
store.restorePurchases()


// Receipt validation for purchased products
store.receiptValidation()

```
## License
[MIT](https://choosealicense.com/licenses/mit/)
