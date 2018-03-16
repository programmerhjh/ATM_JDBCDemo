<%@ page import="com.demo.atm.util.JDBCUtil" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.demo.atm.bean.User" %><%--
  Created by IntelliJ IDEA.
  User: acer
  Date: 2018/3/15
  Time: 20:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>查询余额</title>
</head>
<body>
    <%
        long waitTime = 3000;
        long currentTimeMillis = System.currentTimeMillis();
        long purposeTime = currentTimeMillis + waitTime;
        //未登录访问
        if(session.getAttribute("user") == null){
            while(currentTimeMillis < purposeTime){
                out.println("您还未登录，" + (purposeTime - currentTimeMillis)/1000 + "秒后，跳转到登录页面");
                currentTimeMillis += 1000;
                out.flush();
                Thread.sleep(1000);
                out.println("<script>document.body.innerHTML=\"\";</script>");
            }
            out.println("<script>window.location.href = 'index.jsp'</script>");
            return;
        }

        long uid = ((User)session.getAttribute("user")).getUid();

        Connection connection = null;
        Statement statement = null;
        ResultSet resultSet = null;

        try{
            connection = JDBCUtil.getConnection();
            statement = connection.createStatement();
            resultSet = statement.executeQuery("SELECT * FROM bankacount,user WHERE bankacount.uid=" + uid +" AND user.uid=bankacount.uid;");
            connection.commit();

            //查询余额
            String balance = null;
            //查询用户名
            String username = null;
            while(resultSet.next()){
                balance = resultSet.getString("balance");
                username = resultSet.getString("username");
            }
            if(balance == null || username == null){
                throw new Exception("系统出错");
            }
            out.println("尊敬的"+ username + "，您的账户余额为" + balance);
            out.println("<br>" +
                    "<a href='atmIndex.jsp'>返回ATM操作页面</a>");
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            JDBCUtil.closeResources(connection,statement,resultSet);
        }
    %>

</body>
</html>
