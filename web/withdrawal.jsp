<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="com.demo.atm.util.JDBCUtil" %>
<%@ page import="com.demo.atm.bean.User" %><%--
  Created by IntelliJ IDEA.
  User: acer
  Date: 2018/3/15
  Time: 20:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>取款</title>
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

        //取款参数不合法
        if(!request.getParameter("withdrawalMoney").toString().matches("[\\d]+")){
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

        double withdrawalMoney = Double.parseDouble(request.getParameter("withdrawalMoney"));
        long uid = ((User)session.getAttribute("user")).getUid();

        Connection connection = null;
        Statement statement = null;
        ResultSet resultSet = null;

        try{
            connection = JDBCUtil.getConnection();
            statement = connection.createStatement();
            resultSet = statement.executeQuery("SELECT * FROM bankacount WHERE uid=" + uid);
            connection.commit();

            double balance = 0;
            while (resultSet.next()){
                balance = Double.parseDouble(resultSet.getString("balance"));
            }

            if(balance < withdrawalMoney){
                while(currentTimeMillis < purposeTime){
                    out.println("账户余额不足，" + (purposeTime - currentTimeMillis)/1000 + "秒后，跳转到ATM操作页面");
                    currentTimeMillis += 1000;
                    out.flush();
                    Thread.sleep(1000);
                    out.println("<script>document.body.innerHTML=\"\";</script>");
                }
                out.println("<script>window.location.href = 'atmIndex.jsp'</script>");
                return;
            }

            //修改取款后的数值
            statement.executeUpdate("UPDATE bankacount SET balance=" + (balance - withdrawalMoney) + " WHERE uid=" + uid);
            resultSet = statement.executeQuery("SELECT * FROM bankacount WHERE uid=" + uid);
            connection.commit();
            while (resultSet.next()){
                balance = Double.parseDouble(resultSet.getString("balance"));
            }

            out.println("取款成功！<br><br>尊敬的" + ((User)session.getAttribute("user")).getUsername() + "用户，您当前账户余额为" + balance + "。" +
                    "<br><br>" +
                    "<a href='atmIndex.jsp'>返回ATM操作页</a>");

//            while(currentTimeMillis < purposeTime){
//                out.println("取款成功，" + (purposeTime - currentTimeMillis)/1000 + "秒后，跳转到ATM操作页面");
//                currentTimeMillis += 1000;
//                out.flush();
//                Thread.sleep(1000);
//                out.println("<script>document.body.innerHTML=\"\";</script>");
//            }
//            out.println("<script>window.location.href = 'atmIndex.jsp'</script>");
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            JDBCUtil.closeResources(connection,statement,resultSet);
        }

    %>
</body>
</html>
