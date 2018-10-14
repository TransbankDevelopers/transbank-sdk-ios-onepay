# Transbank SDK iOS Onepay

## Instalación

- Descarga el SDK como binario en un archivo `.framework` desde desde [la página de releases](https://github.com/TransbankDevelopers/transbank-sdk-ios-onepay/releases). Para comenzar el desarrollo puedes usar la versión para ambiente de Test (y luego deberás compilar contra la versión de Producción para tu app productiva)
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


[TODO]