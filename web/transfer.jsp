<%@ page import="com.demo.atm.util.JDBCUtil" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.demo.atm.bean.User" %><%--
  Created by IntelliJ IDEA.
  User: acer
  Date: 2018/3/15
  Time: 19:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>转账页面</title>
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


        String transferUsername = request.getParameter("transferUsername");
        double transferMoney;
        if(transferUsername == null || !request.getParameter("transferMoney").toString().matches("[\\d]+") ){
            while(currentTimeMillis < purposeTime){
                out.println("转账信息有误，" + (purposeTime - currentTimeMillis)/1000 + "秒后，跳转到ATM操作页面");
                currentTimeMillis += 1000;
                out.flush();
                Thread.sleep(1000);
                out.println("<script>document.body.innerHTML=\"\";</script>");
            }
            out.println("<script>window.location.href = 'atmIndex.jsp'</script>");
            return;
        }
        transferMoney = Double.parseDouble(request.getParameter("transferMoney"));
        long uid = ((User)session.getAttribute("user")).getUid();
        Connection connection = null;
        Statement statement = null;
        ResultSet resultSet = null;
        try {
            connection = JDBCUtil.getConnection();
            statement = connection.createStatement();
            resultSet = statement.executeQuery("SELECT balance FROM bankacount where uid=" + uid );
            connection.commit();

            double balance = 0;
            while (resultSet.next()){
                balance = Double.parseDouble(resultSet.getString("balance"));
            }
            //余额不足
            if (transferMoney > balance){
                while(currentTimeMillis < purposeTime){
                    out.println("余额不足，" + (purposeTime - currentTimeMillis)/1000 + "秒后，跳转到ATM操作页面");
                    currentTimeMillis += 1000;
                    out.flush();
                    Thread.sleep(1000);
                    out.println("<script>document.body.innerHTML=\"\";</script>");
                }
                out.println("<script>window.location.href = 'atmIndex.jsp'</script>");
                return;
            }
            resultSet = statement.executeQuery("SELECT user.uid transferId,balance FROM user,bankacount WHERE username='" + transferUsername + "'  AND bankacount.uid=user.uid;");
            connection.commit();
            int rows = 0;
            long transferId = 0;
            double transferBalance = 0;
            while (resultSet.next()){
                rows = resultSet.getRow();
                transferId = Long.parseLong(resultSet.getString("transferId"));
                transferBalance = Double.parseDouble(resultSet.getString("balance"));
            }
            //转账人信息错误
            if(rows < 1){
                while(currentTimeMillis < purposeTime){
                    out.println("转账信息填写错误，" + (purposeTime - currentTimeMillis)/1000 + "秒后，跳转到ATM操作页面");
                    currentTimeMillis += 1000;
                    out.flush();
                    Thread.sleep(1000);
                    out.println("<script>document.body.innerHTML=\"\";</script>");
                }
                out.println("<script>window.location.href = 'atmIndex.jsp'</script>");
                return;
            }

            //减去登录账户人的余额
            statement.executeUpdate("UPDATE bankacount SET balance=" + (balance - transferMoney) + " WHERE uid=" + uid);
            //加上收账人的余额
            statement.executeUpdate("UPDATE bankacount SET balance=" + (transferBalance + transferMoney) + " WHERE uid=" + transferId);
            connection.commit();


            while(currentTimeMillis < purposeTime){
                out.println("转账成功，" + (purposeTime - currentTimeMillis)/1000 + "秒后，跳转到ATM操作页面");
                currentTimeMillis += 1000;
                out.flush();
                Thread.sleep(1000);
                out.println("<script>document.body.innerHTML=\"\";</script>");
            }
            out.println("<script>window.location.href = 'atmIndex.jsp'</script>");
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            JDBCUtil.closeResources(connection,statement,resultSet);
        }

    %>
</body>
</html>
