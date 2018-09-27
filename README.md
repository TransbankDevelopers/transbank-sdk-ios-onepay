# Transbank SDK iOS Onepay

## Instalación

- Descarga el SDK como binario en un archivo `.framework` desde desde [la página de releases](https://github.com/TransbankDevelopers/transbank-sdk-ios-onepay/releases).  El SDK sirve tanto para desarrollo como para producción.
- Descomprime el archivo `.zip` para quedar con el directorio `.framework`.
- Arrastra `OnePaySDK` a la sección "Embedded Binaries" en la configuración "General" de tu proyecto. Marca la casilla "Copy items if needed" y haz click en "Finish"
- En el archivo Info.plist, agrega lo siguiente para que tu aplicación pueda consultar si existe Onepay:

```
<key>LSApplicationQueriesSchemes</key>
  <array>
    <string>onepay</string>        
  </array>
```

## Modo de uso  

### Detección e Instalación de app Onepay

Para detectar si Onepay está disponible e invitar al usuario a instalarlo:

```swift
import OnePaySDK
//...

let onepay = OnePay()
if (onepay.isOnePayInstalled()) {
     // Todo OK, sigue adelante             
} else {
    // Ofrece al usuario si quiere instalar Onepay. 
    // En caso que esté de acuerdo, usa lo siguiente para iniciar la instalación:
    onepay.installOnePay()
}
```

### Iniciar una transacción

En tu backend debes crear una transacción indicando el `channel` `MOBILE` y el `appSchema` que corresponda a tu app. Luego debes transmitir a tu app el `occ` obtenido en el backend. Con ese dato puedes iniciar el pago usando la clase `OnePay`:

```swift
import OnePaySDK
import os.log
//...

let onepay = OnePay();
onepay.initPayment("occ",
    callback: {(statusCode, description) in
        switch statusCode {
        case OnePayState.occInvalid:
            // Algo anda mal con el occ que obtuviste desde el backend
            // Debes reintentar obtener el occ o abortar        
            os_log("OCC inválida")
        case OnePayState.notInstalled:
            // Onepay no está instalado.
            // Debes abortar o pedir al usuario instalar Onepay (y luego reintentar initPayment)        
            os_log("Onepay no instalado")
        }
    }
)
```

Si todo funciona OK, el control pasará a la app Onepay donde el usuario podrá autorizar la transacción.

### Recibir el callback después que el usuario autoriza el pago

Una vez se complete el pago, Onepay redigirá el control de regreso a tu app mediante el `appSchema` indicado en el backend al crear la transacción. Tu debes registrar ese esquema en tu app móvil y procesar la invocación cuando ocurra. Por ejemplo, si tu `appSchema` fuera `mi-app://mi-app/onepay-result` debes agregar algo como lo siguiente a tu `Info.plist`:

```xml
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>mi-app</string>
			</array>
			<key>CFBundleURLName</key>
			<string>cl.micomercio.mi-app</string>
		</dict>
	</array>
 ```
(O alternativamente, puedes registrar tu esquema interactivamente en la sección "URL Types" en la pestaña "Info" de la configuración de tu proyecto)


Luego en tu `AppDelegate` debes procesar la URL. Por ejemplo:

```swift
func application(_ app: UIApplication, open url: URL,
                 options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {

    let sendingAppID = options[.sourceApplication]
    print("source application = \(sendingAppID ?? "Unknown")")
    guard
        let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
        let host = components.host,
        let path = components.path,
        let params = components.queryItems
        else {
            os_log("URL, host, path o params inválidos: %s", url.absoluteString)
            return false
    }
    if (host == "mi-app" && path == "onepay-result") {
        guard
            let occ = params.first(where: { $0.name == "occ" })?.value,
            let externalUniqueNumber = params.first(where: { $0.name == "externalUniqueNumber" })?.value
            else {
                os_log("Falta un parámetro occ o externalUniqueNumber: %s", url.absoluteString)
                return false
        }
        // Envia el occ y el externalUniqueNumber a tu backend para que
        // confirme la transacción
        print(occ, externalUniqueNumber)

    } else {
        // Otras URLs que quizás maneja tu app
    }
    return false

}
```

## Nota

A diferencia de otros SDK, en iOS se usa `OnePay` en lugar de `Onepay` (nombre correcto del producto) . Esto obedece a razones históricas.

## Generar una nueva versión

Para generar una nueva versión, se debe crear un PR (con un título "Prepare release X.Y.Z" con los valores que correspondan para `X`, `Y` y `Z`). Se debe seguir el estándar semver para determinar si se incrementa el valor de `X` (si hay cambios no retrocompatibles), `Y` (para mejoras retrocompatibles) o `Z` (si sólo hubo correcciones a bugs).

En ese PR deben incluirse los siguientes cambios:

1. Modificar el archivo CHANGELOG.md para incluir una nueva entrada (al comienzo) para `X.Y.Z` que explique en español los cambios.

Luego de obtener aprobación del pull request, debes mezclar a master e inmediatamente generar un release en GitHub con el tag `vX.Y.Z`. En la descripción del release debes poner lo mismo que agregaste al changelog.

Con eso Travis CI generará automáticamente una nueva versión del plugin y actualizará el Release de Github con el zip del plugin.
