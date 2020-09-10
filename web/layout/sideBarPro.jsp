<%-- 
    Document   : menu
    Created on : 28/04/2020, 12:32:48 AM
    Author     : Daniel
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div class="sidebar">
    <h3 class="sticky-top"><a href="index.jsp" title="inicio"><img src="../../img/logo-mowo-solo.png" width="60px" height="60px">Profesor</a></h3>
    <div class="perfil">
        <h5 class="text-center pt-4"><%=session.getAttribute("nameUser")%></h5>
        <h6 class="text-center"><%=session.getAttribute("email")%></h6>
    </div>
    <a href="perfil.jsp" title="Ver Perfil"><img src="../../img/avatar.jpg" ></a>
    <div class="logo">
        <a href="../../LoginSERVLET?logout=1" title="Salir"><img src="../../img/salir.png" alt="Salir" ></a>
    </div>
    <ul>
        <li><a href="index.jsp">Inicio</a></li>
        <li><a href="notas.jsp"> Notas</a></li>
       <!-- <li><a href="asistencia.jsp">Asistencia</a></li> 
        <li><a href="observaciones.jsp">Observaciones</a></li>
        <li><a href="horario.jsp">Horario</a></li> -->
    </ul>
</div>
