<%@ page import="java.sql.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.commschool.scheduler.*" %>
<%@ page import="org.commschool.scheduler.db.*" %>

<%@ page errorPage="/exception.jsp" %>

<%
String db_class = "com.mysql.jdbc.Driver";
String db_url = "jdbc:mysql://127.0.0.1/scheduler";
String db_username = "scheduler";
String db_password = "";

Connection connect = (Connection)session.getAttribute("db");
if (connect != null) {
	try {
		connect.prepareStatement("select 0").execute();
	} catch (SQLException sqlex) {
		connect = null;
	}
}
if (connect == null) {
    try {
        Class.forName(db_class).newInstance();
        connect = DriverManager.getConnection(db_url, db_username, db_password);
        connect.setAutoCommit(true);
		session.setAttribute("db", connect);
    } catch (Exception e) {
        %>Internal error! Unable to connect to database.<%
        throw e;
    }
}

Statement init_state;
ResultSet init_result;

init_state = connect.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);

boolean schedulingDone;

init_result = init_state.executeQuery("select count(*) from conference");
if (init_result.first()) {
	schedulingDone = (init_result.getInt(1) > 0);
} else {
	schedulingDone = false;
}

String studentName;
int studentID;
String studentEmail;
boolean studentHasSignedIn;
boolean studentHasSetAvail;
boolean studentHasSetPrefs;
boolean studentHasSetEmail;

if (session.getAttribute("studentID") != null) {
	studentID = ((Integer)session.getAttribute("studentID")).intValue();
	init_result = init_state.executeQuery("select * from students where studentID = " + studentID);
	if (init_result.first()) {
		studentName        = init_result.getString("name");
		studentEmail       = init_result.getString("email");
		studentHasSignedIn = init_result.getInt("hasSignedIn") != 0;
		studentHasSetAvail = init_result.getInt("hasSetAvail") != 0;
		studentHasSetPrefs = init_result.getInt("hasSetPrefs") != 0;
		studentHasSetEmail = init_result.getString("email") != null;
	} else {
		studentID = 0;
		studentName = studentEmail = "";
		studentHasSignedIn = studentHasSetAvail = studentHasSetPrefs = studentHasSetEmail = false;
	}
} else {
	studentID = 0;
	studentName = studentEmail = "";
	studentHasSignedIn = studentHasSetAvail = studentHasSetPrefs = studentHasSetEmail = false;
}

String teacherName;
String teacherRoom;
int teacherID;
String teacherEmail;
boolean teacherHasSignedIn;
boolean teacherHasSetAvail;
boolean teacherHasSetPrefs;
boolean teacherHasSetEmail;

if (session.getAttribute("teacherID") != null) {
	teacherID = ((Integer)session.getAttribute("teacherID")).intValue();
	init_result = init_state.executeQuery("select * from teachers where teacherID = " + teacherID);
	if (init_result.first()) {
		teacherName        = init_result.getString("name");
		teacherEmail       = init_result.getString("email");
		teacherRoom 	   = init_result.getString("room");
		teacherHasSignedIn = init_result.getInt("hasSignedIn") != 0;
		teacherHasSetAvail = init_result.getInt("hasSetAvail") != 0;
		teacherHasSetPrefs = init_result.getInt("hasSetPrefs") != 0;
		teacherHasSetEmail = init_result.getString("email") != null;
	} else {
		teacherID = 0;
		teacherName = teacherEmail = teacherRoom = "";
		teacherHasSignedIn = teacherHasSetAvail = teacherHasSetPrefs = teacherHasSetEmail = false;
	}
} else {
	teacherID = 0;
	teacherName = teacherEmail = teacherRoom = "";
	teacherHasSignedIn = teacherHasSetAvail = teacherHasSetPrefs = teacherHasSetEmail = false;
}

%>
