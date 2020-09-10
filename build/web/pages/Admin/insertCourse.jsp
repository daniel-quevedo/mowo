<%-- 
    Document   : insertUser
    Created on : 30-abr-2020, 22:49:36
    Author     : Daniel
--%>

<!--VALIDAR QUE EL USUARIO TENGA LA SESION ACTIVA Y SEA ADMINISTRADOR************************-->

<%@include file="../../includes/Admin/ValidateSession.jsp"%> 

<!--*****************************************************************************************-->

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="../../layout/head.jsp"></jsp:include>
            <title>Insertar Usuarios</title>
        </head>
        <body>
            <main>
                <header>
                <jsp:include page="../../layout/sideBarAdm.jsp"></jsp:include>
                </header>
                <section>
                    <div class="contenido">
                        <jsp:include page="../../layout/line-top.jsp"></jsp:include>
                        <div class="contenedor">
                            <h5 class="text-center mb-4">Insertar Cursos</h5>
                            <form action="../../CrudCourseSERVLET" method="POST">
                                <input type="hidden" name="option" value="1">
                                <table class="table backg table-borderless col-md-6 col-12 mt-2">
                                    <thead>
                                        <tr>
                                            <th>Jornada:</th>
                                            <th>Código:</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr class="tt">
                                            <td><input type="text" class="form-control" name="name" id="name" value="" autofocus pattern="([J]+[T,M])" placeholder="JM / JT" title="Se debe escribir JM o JT en MAYUSCULAS" required></td>
                                            <td><input type="number" class="form-control" name="code" id="code" value="" min="101" max="1109" pattern="[0-9]" placeholder="ej. 902" required></td>
                                        </tr>                                                                
                                    <th colspan="2">
                                        <button type="submit" name="save" class="btn btn-success">Guardar</button>
                                        <button class="btn btn-danger" type="reset">Cancelar</button>
                                    </th>
                                    </tbody>
                                </table>
                            </form>
                        </div>
                    </div>
                </section>
            </main>

        <jsp:include page="../../layout/scripts.jsp"></jsp:include>


            <!-- Validar si el curso fue ingresado correctamente y mostrar el mensaje correspondiente-->
        <jsp:include page="../../includes/Admin/ValidateInsertCourse.jsp"></jsp:include>   
    </body>
</html>

</head>
<body>
    <h1>Hello World!</h1>
</body>
</html>
