package com.demo.atm.util;


import java.sql.*;

/**
 * @author 洪家豪
 *         Created by acer on 2018/3/15.
 */
public class JDBCUtil {

    private static Connection connection;

    private static String URL = "jdbc:mysql://localhost:3306/atm?useUnicode=true&&characterEncoding=utf-8";

    private static String USER = "root";

    private static String PASSWORD = "123456";

    private JDBCUtil(){}

    public static Connection getConnection() throws Exception {
        if(connection != null && !connection.isClosed()){
            return connection;
        }
        try{
            Class.forName("com.mysql.jdbc.Driver");
            connection = DriverManager.getConnection(URL,USER,PASSWORD);
            connection.setAutoCommit(false);
        }catch (Exception e){
            e.printStackTrace();
        }
        return connection;
    }

    public static void closeResources(Connection connection,Statement statement,ResultSet resultSet) throws Exception {
        if(resultSet != null){
            resultSet.close();
        }
        if(statement != null){
            statement.close();
        }
        if(connection != null){
            connection.close();
        }
    }
}
