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

## Documentación 

Puedes encontrar toda la documentación de cómo usar este SDK en el sitio https://www.transbankdevelopers.cl.

La documentación relevante para usar este SDK es:

- Documentación general sobre el producto
  [Onepay](https://www.transbankdevelopers.cl/producto/onepay).
- Documentación sobre [ambientes, deberes del comercio, puesta en producción,
  etc](https://www.transbankdevelopers.cl/documentacion/como_empezar#ambientes).
- Primeros pasos con [Onepay](https://www.transbankdevelopers.cl/documentacion/onepay).
- Referencia detallada sobre [Onepay](https://www.transbankdevelopers.cl/referencia/onepay).

## Información para contribuir y desarrollar este SDK

Para generar una nueva versión, se debe crear un PR (con un título "Prepare release X.Y.Z" con los valores que correspondan para `X`, `Y` y `Z`). Se debe seguir el estándar semver para determinar si se incrementa el valor de `X` (si hay cambios no retrocompatibles), `Y` (para mejoras retrocompatibles) o `Z` (si sólo hubo correcciones a bugs).

En ese PR deben incluirse los siguientes cambios:

1. Modificar el archivo CHANGELOG.md para incluir una nueva entrada (al comienzo) para `X.Y.Z` que explique en español los cambios.

Luego de obtener aprobación del pull request, debes mezclar a master e inmediatamente generar un release en GitHub con el tag `vX.Y.Z`. En la descripción del release debes poner lo mismo que agregaste al changelog.

Con eso Travis CI generará automáticamente una nueva versión del framework y actualizará el Release de Github con el framework comprimido.
