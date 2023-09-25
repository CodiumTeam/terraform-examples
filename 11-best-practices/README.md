# Best practices

### Naming conventions
covnención de nombres, _ en lugar de -, no redundancia (no repetir el tipo de recurso en el nombre del recurso)
nombrar las variables numericas con unidades, ej: ram_size_gb

usar outputs
tag your resources

proteger recursos con estado lifecycle { prevent_destroy = true }

pinear versiones en modulos externos


poner count/for_each en primera linea del bloque


use variable validations

