<%--
  Created by IntelliJ IDEA.
  User: acer
  Date: 2018/3/15
  Time: 20:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>登出</title>
</head>
<body>
    <%
        long waitTime = 3000;
        long currentTimeMillis = System.currentTimeMillis();
        long purposeTime = currentTimeMillis + waitTime;
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
        session.invalidate();
        while(currentTimeMillis < purposeTime){
            out.println("注销成功，" + (purposeTime - currentTimeMillis)/1000 + "秒后，跳转到登录页面");
            currentTimeMillis += 1000;
            out.flush();
            Thread.sleep(1000);
            out.println("<script>document.body.innerHTML=\"\";</script>");
        }
        out.println("<script>window.location.href = 'index.jsp'</script>");
    %>
</body>
</html>
