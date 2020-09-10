<%-- 
    Document   : menu
    Created on : 21-abr-2020, 8:17:04
    Author     : Daniel
--%>



<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <jsp:include page="../../layout/head.jsp"></jsp:include>
            <title>Menu</title>
        </head>
        <body>
            <main>
                <header>
                <jsp:include page="../../layout/sideBarTutor.jsp"></jsp:include>
                </header>

                <section>
                    <div class="contenido">
                        <jsp:include page="../../layout/line-top.jsp"></jsp:include>
                        <div class="contenedor mt-4">
                            <div class="index">
                                <img src="../../img/logo-mowo-lateral.png" >                        
                                <h1 class=" ml-1 mt-3"> Bienvenido/a </h1>                        
                                <h3 class="mt-3"><%=session.getAttribute("nameUser")%></h3>   
                        </div>                   
                    </div>
                </div>
            </section>
        </main>

        <jsp:include page="../../layout/scripts.jsp"></jsp:include>
    </body>
</html>

