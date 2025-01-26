
<%@ Page Language="C#" AutoEventWireup="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to API</title>
</head>
<body>
    <h1>Welcome to API</h1>
    <p>
        <asp:Literal ID="Message" runat="server"></asp:Literal>
    </p>
</body>
</html>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        // Dynamically generate a welcome message based on the time of day
        var hour = DateTime.Now.Hour;
        string message;

        if (hour < 12)
            message = "Good Morning!";
        else if (hour < 18)
            message = "Good Afternoon!";
        else
            message = "Good Evening!";

        // Assign the message to the Literal control
        Message.Text = message + " The current time is " + DateTime.Now.ToString("hh:mm tt");
    }
</script>
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <system.web>
    <compilation debug="true" targetFramework="4.7.2" />
    <httpRuntime targetFramework="4.7.2" />
  </system.web>
</configuration>