### PatchMe ###
PatchMe es un sencillo interfaz gráfico para Windows que utiliza [xdelta3] (https://github.com/jmacd/xdelta) para crear parches para más de un archivo a la vez, y ha sido creado por un tipo que no tiene ni idea de programación. ¡Huid, insensatos!

##### Uso #####
1. Añadir los archivos originales en la caja "Archivos de origen".
2. Añadir los archivos modificados o finales en la caja "Archivos de destino".
   - (Los archivos pueden ser arrastrados desde Windows o pulsando el botón "Añadir origen/destino". Se pueden arrastras varios archivos y carpetas a la vez y ordenarlos arrastrándolos con el ratón).
3. En la parte inferior modifica las opciones que desees y pulsa el botón "Crear".
4. En la ventana que aparecerá elige el lugar y el nombre que tendrán los archivos .sh, .bat y .zip.

```
Se puede pulsar con el botón derecho del ratón en ambas cajas para acceder
a un menú contextual con varias opciones.

Tanto la posición como el tamaño de la ventana y las rutas que se han usado para
añadir y guardar los archivos se guardarán al cerrar la aplicación.
```


##### Opciones #####
- `Comprimir archivos en zip:` Todos los archivos generados se comprimirán en un archivo .zip al terminar el proceso.
- `Borrar los archivos intermedios:` Los archivos generados se borrarán después de comprimirse en .zip.
- `Usar nombre para .xdelta:` Si está desactivado, los archivos .xdelta tendrán el nombre "fileX.xdelta", donde X es un número. Si está activado, el nombre de los archivos será el mismo que el de los archivos de origen o destino.
- `Búfer:` Especifica el "horizonte" máximo por el que xdelta buscará diferencias entre los dos archivos. Para una información más detallada, visita este [enlace] (https://github.com/jmacd/xdelta/blob/wiki/TuningMemoryBudget.md).
