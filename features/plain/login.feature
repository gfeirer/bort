Característica: Login
  Para acceder a la aplicación
  Un usuario
  Debería visitar la portada e introducir su nombre de usuario y contraseña 

  Escenario: Login
    Cuando visito "la portada"
    Entonces debería ver "Login"

  Escenario: Login correcto
    Dado que tengo una cuenta activa con nombre de usuario "pepito"
    Cuando visito "la portada"
    Y me logeo como "pepito"
    Entonces debería ver "Sesión iniciada correctamente"
 
  Escenario: Nombre de usuario y contraseña incorrecta
    Dado que tengo una cuenta activa con nombre de usuario "pepito"
    Cuando visito "la portada"
    Y me logeo como "pepito" con contraseña errónea
    Entonces debería ver "Nombre de usuario o contraseña incorrectos"
    
