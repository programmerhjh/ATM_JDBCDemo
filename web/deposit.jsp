<%@ page import="java.sql.Connection" %>
<%@ page import="com.demo.atm.bean.User" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.demo.atm.util.JDBCUtil" %><%--
  Created by IntelliJ IDEA.
  User: acer
  Date: 2018/3/15
  Time: 21:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>存款页面</title>
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

    //存款参数不合法
    if(!request.getParameter("deposit").toString().matches("[\\d]+")){
        while(currentTimeMillis < purposeTime){
            out.println("输入参数有误，" + (purposeTime - currentTimeMillis)/1000 + "秒后，跳转到ATM操作页面");
            currentTimeMillis += 1000;
            out.flush();
            Thread.sleep(1000);
            out.println("<script>document.body.innerHTML=\"\";</script>");
        }
        out.println("<script>window.location.href = 'atmIndex.jsp'</script>");
        return;
    }

    double deposit = Double.parseDouble(request.getParameter("deposit"));
    long uid = ((User)session.getAttribute("user")).getUid();



    Connection connection = null;
    Statement statement = null;
    ResultSet resultSet = null;

    try{
        connection = JDBCUtil.getConnection();
        statement = connection.createStatement();
        resultSet = statement.executeQuery("SELECT balance FROM bankacount WHERE uid=" + uid);
        connection.commit();

        //查出原来的余额
        float balance = 0;
        while (resultSet.next()){
            balance = Float.parseFloat(resultSet.getString("balance"));
        }
        statement.executeUpdate("UPDATE bankacount SET balance=" + (balance + deposit) + " WHERE uid=" + uid);
        resultSet = statement.executeQuery("SELECT bankacount.balance,user.username FROM bankacount,user WHERE bankacount.uid=" + uid +" AND user.uid=bankacount.uid;");
        connection.commit();

        String username = null;
        while (resultSet.next()){
            username = resultSet.getString("username");
            balance = Float.parseFloat(resultSet.getString("balance"));
        }
        if(username == null && balance == 0){
            throw new Exception("系统出错");
        }
        out.println("存款成功！<br><br> 尊敬的"+ username +
                "用户，您目前的账户余额为"+ balance +
                "。<br><br><br>" +
                "<a href='atmIndex.jsp'>返回ATM操作页</a>");
    }catch (Exception e){
        e.printStackTrace();
    }finally {
        JDBCUtil.closeResources(connection,statement,resultSet);
    }

%>
</body>
</html>
