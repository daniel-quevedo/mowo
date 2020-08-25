<%-- 
    Document   : assocSubjectCourse
    Created on : 17/08/2020, 12:06:38 AM
    Author     : Leonardo
--%>

<%@page import="DAOAdmin.AssocSubjectDAO"%>
<%@page import="VOAdmin.AssocSubjectVO"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="DAOAdmin.AssocCourseDAO"%>
<%@page import="VOAdmin.AssocCourseVO"%>
<%

    //traer los datos de los cursos***
    AssocCourseVO DcoStuV = new AssocCourseVO(0, 0, "");

    AssocCourseDAO TuStu = new AssocCourseDAO(DcoStuV);

    ResultSet resCourse = TuStu.listCourse(1);

    //traer las asignaturas ******************
    AssocSubjectVO asSubjectVO = new AssocSubjectVO(0, 0, 0, "");
    AssocSubjectDAO asSubjectDAO = new AssocSubjectDAO(asSubjectVO);

    ResultSet listSubjects = asSubjectDAO.listSubjects();


%>


<!--VALIDAR QUE EL USUARIO TENGA LA SESION ACTIVA Y SEA ADMINISTRADOR************************-->

<%@include file="../../includes/Admin/ValidateSession.jsp"%> 

<!--*****************************************************************************************-->


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="../../layout/head.jsp"></jsp:include>
            <title>Asignar asignatura</title>
        </head>
        <body>
            <main>
                <header>
                <jsp:include page="../../layout/sideBarAdm.jsp"></jsp:include>
                </header>
                <section>

                    <div class="contenido">
                        <div class="line-top sticky-top">
                            <img src="../../img/menu.png" alt="" class="menu-bar">
                        </div>
                        <div class="contenedor">
                            <h5 class="mb-4 text-center">Asignar asignaturas a un curso</h5>
                            <br>
                            <form action="../../AssocSubjectSERVLET" method="POST">
                                <input type="hidden" name="opt" value="B">  
                                <input type="hidden" name="option" value="1">
                                <input type="hidden" name="idTeacher" value="0">
                                <div class="row text-center justify-content-center">
                                    <div class=" col-8">
                                        <label> Seleccion un curso </label>
                                        <select class="form-control" id="idCourse" name="idCourse" autofocus required>
                                            <option value="#" selected>--SELECCIONE--</option>
                                        <%                                                while (resCourse.next()) {
                                                out.println("<option value='" + resCourse.getInt(1) + "'>" + resCourse.getString(2) + "</option>");
                                            }
                                        %>
                                    </select> 
                                </div>
                            </div>
                            <br>

                            <div class="row mb-3">

                                <div class="t-fixed col-lg-8 col-sm-10 col-12">

                                    <table class="table table-hover table-borderless backg table-responsive-sm" id="dataSubject">
                                        <thead class="text-center">
                                            <tr>
                                                <th><i data-feather="check"></i></th>
                                                <th>Nombre</th>
                                                <th>Salón</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                while (listSubjects.next()) {
                                                    out.println("<tr>");
                                                    out.println("<td>\n"
                                                            + "<input type='checkbox' name='subject' value='" + listSubjects.getInt(1) + "'>\n"
                                                            + "</td>");
                                                    out.println("<td> " + listSubjects.getString(2) + " </td>");
                                                    out.println("<td> " + listSubjects.getString(3) + " </td>");
                                                    out.println("</tr>");
                                                }

                                                asSubjectDAO.closeConnection();
                                            %>
                                        </tbody>

                                    </table>
                                </div>

                            </div>
                            <div class="row mb-3 justify-content-center">
                                <button type="submit" name="send" id="send" class="btn btn-success"> Aceptar </button>
                            </div>
                        </form>
                    </div>
                </div>
            </section>
            <!--Ventana Modal -->
            <jsp:include page="../../layout/modalUser.jsp"></jsp:include>
            </main>

        <jsp:include page="../../layout/scripts.jsp"></jsp:include>

            <!--Validar cambio de estado del select-->
            <script src="../../js/Admin/ShowSubjectAssoc.js"></script>

            <!-- Validar si se asociaron correctemente los asignaturas-->
        <jsp:include page="../../includes/Admin/ValidateAssocSubject.jsp"></jsp:include> 


        <!--implementar select2********-->
        <script>

            $(document).ready(function () {
                $('#idCourse').select2();
            });

        </script>

    </body>
</html>

