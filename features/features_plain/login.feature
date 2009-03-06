Característica: Login
  Para acceder a la aplicación
  Un usuario
  Debería visitar la portada e introducir su nombre de usuario y contraseña 

  Escenario: Login
    Cuando visito la portada
    Entonces debería ver "Login"

  Escenario: Login correcto
    Cuando visito la portada
    Y me logeo
    Entonces debería ver "Sesión iniciada correctamente"
 
  Escenario: Nombre de usuario y contraseña incorrecta
    Cuando visito la portada
    Y me logeo incorrectamente
    Entonces debería ver "Nombre de usuario o contraseña incorrectos"
    
