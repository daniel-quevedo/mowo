/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DAOAdmin;

import DAO.LoginDAO;
import VOAdmin.AssocSubjectVO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import util.ClassConnection;

/**
 *
 * @author Daniel
 */
public class AssocSubjectDAO extends ClassConnection{
    
    //VARIABLES DE CONEXION ***********************
    
    private Connection con;
    private PreparedStatement pstm;
    private ResultSet res;
    
    //VARIABLES PARA ASOCIAR AL CURSO ************
    
    private int id_prof;
    private int id_subject;
    private int id_course;
    private String opt;
    
    public AssocSubjectDAO(AssocSubjectVO asVO){
        
        try{
            
            this.con = this.getConnection();
        
            this.id_prof = asVO.getId_prof();
            this.id_subject = asVO.getId_asig();
            this.id_course = asVO.getId_course();
            this.opt = asVO.getOpt();

        }catch(Exception ex){
            Logger.getLogger(LoginDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }
    
    public int assoc(){
        
        int result = 0;
        
        String sqlInsert = "SELECT mowo.f_asociar_asignatura(?,?,?,?);";
        
        //String sqlInsert = "SELECT mowo.f_asociar_asignatura("+id_prof+","+id_subject+","+id_course+","+opt+");";
      
        try{

            this.pstm = this.con.prepareStatement(sqlInsert);
            
            this.pstm.setInt(1, id_prof);
            this.pstm.setInt(2, id_subject);
            this.pstm.setInt(3, id_course);
            this.pstm.setString(4, opt);

            this.res = this.pstm.executeQuery();
            

            if (this.res.next()) {
                
                result = this.res.getInt(1);
                
            }
            

        }catch(SQLException ex){

            System.out.println("ocurrio un error al asociar el usuario" + ex);

        }
        
        return result;
        
    }
    
//    public static void main(String[] args) {
//        
//        try{
//           
//            //PARA ASOCIAR EL PROFESOR SE NECESITA EL ID_PROF Y ID_ASIG 
//            
//            AssocSubjectVO acVO = new AssocSubjectVO(8,9,0,"A");
//            
//            //PARA ASOCIAR EL CURSO Y LA ASIGNATURA SE NECESITA ID_ASIG Y ID_CURSO
//            
//            //AssocSubjectVO acVO = new AssocSubjectVO(0,9,3,"B");
//
//            AssocSubjectDAO objP = new AssocSubjectDAO(acVO);
//            
//            System.out.println(objP.assoc());
//
//       }catch(Exception ex){
//           
//           
//       }
//        
//    }
    
}
