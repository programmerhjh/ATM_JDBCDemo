<%@ page import="com.demo.atm.util.JDBCUtil" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.demo.atm.bean.User" %>
<%--
  Created by IntelliJ IDEA.
  User: acer
  Date: 2018/3/15
  Time: 12:19
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>ATM首页</title>
</head>
<body>
    <%
        long waitTime = 3000;
        long currentTimeMillis = System.currentTimeMillis();
        long purposeTime = currentTimeMillis + waitTime;
        if((request.getParameter("username") == null || request.getParameter("password") == null) && session.getAttribute("user") == null){
            //用户密码为空
            while(currentTimeMillis < purposeTime){
                out.println("<script>document.body.innerHTML=\"\";</script>");
                out.println("用户未登录，" + (purposeTime - currentTimeMillis)/1000 + "秒后，跳转到登录页面");
                currentTimeMillis += 1000;
                out.flush();
                Thread.sleep(1000);
            }
            out.println("<script>window.location.href = 'index.jsp'</script>");
//            response.sendRedirect("${pageContext.request.contextPath}/index.jsp");
//            return;
        }else if (session.getAttribute("user") != null){

        }else{
            Connection connection = null;
            Statement statement = null;
            ResultSet resultSet = null;
            try {

                String username = request.getParameter("username");
                String password = request.getParameter("password");
                connection = JDBCUtil.getConnection();
                statement = connection.createStatement();
                resultSet = statement.executeQuery("SELECT uid FROM user where username='"+ username + "' and password='" + password + "';");
                connection.commit();

                //结果集条数
                int count = 0;
                String userId = "";
                while(resultSet.next()){
                    count = resultSet.getRow();
                    userId = resultSet.getString("uid");
                }
                if(count > 0){
                    User user =  new User();
                    user.setUid(Long.parseLong(userId));
                    user.setUsername(username);
                    session.setAttribute("user",user);
                } else {
                    while(currentTimeMillis < purposeTime){
                        out.println("<script>document.body.innerHTML=\"\";</script>");
                        out.println("用户名或密码错误，" + (purposeTime - currentTimeMillis)/1000 + "秒后，跳转到登录页面");
                        currentTimeMillis += 1000;
                        out.flush();
                        Thread.sleep(1000);
                    }
                    out.println("<script>window.location.href = 'index.jsp'</script>");
                }
            }catch (Exception e){
                e.printStackTrace();
            }finally {
                JDBCUtil.closeResources(connection,statement,resultSet);
            }
        }
    %>
    <h1>ATM操作页面</h1>
    <h3>尊敬的<%= ((User)session.getAttribute("user")).getUsername()%>,你好</h3>
    <form action="transfer.jsp" method="post">
        <label for="transferUsername">收账人用户名
            <input type="text" name="transferUsername" id="transferUsername" placeholder="请输入转账者用户名">
        </label>
        <label for="transferMoney">转账金额
            <input type="text" name="transferMoney" id="transferMoney" placeholder="请输入转账金额">
        </label>
        <input type="submit" value="转账">
    </form>

    <br>
    <br>

    <form action="withdrawal.jsp" method="post">
        <label for="withdrawalMoney">取款金额
            <input type="text" placeholder="取款金额" id="withdrawalMoney"
                   name="withdrawalMoney">
        </label>
        <input type="submit" value="取款">
    </form>

    <br>
    <br>

    <form action="deposit.jsp" method="post">
        <label for="deposit">存款金额
            <input type="text" placeholder="存款金额" id="deposit"
                   name="deposit">
        </label>
        <input type="submit" value="存款">
    </form>

    <br>
    <br>

    <a href="checkbalance.jsp">查询余额</a>

    <br>
    <br>

    <a href="logout.jsp">登出</a>

</body>
</html>
