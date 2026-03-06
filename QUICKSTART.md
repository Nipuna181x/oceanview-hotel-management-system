# Quick Start Guide - Ocean View Hotel Management System

This is a condensed setup guide for experienced developers. For detailed instructions, see SETUP_GUIDE.md.

---

## Prerequisites Checklist

- [ ] JDK 17 installed (`java -version`)
- [ ] Maven 3.6+ installed (`mvn -version`)
- [ ] MySQL 8.0+ running (`mysql -V`)
- [ ] Apache Tomcat 9.x installed
- [ ] Git installed (optional)

---

## 5-Minute Setup

### Step 1: Database Setup (2 minutes)

```bash
# Login to MySQL
mysql -u root -p

# Run the schema file
source /path/to/database_schema.sql

# Or manually:
CREATE DATABASE oceanviewresort_hms;
USE oceanviewresort_hms;
# Then execute all SQL from database_schema.sql
```

### Step 2: Configure Project (30 seconds)

Edit `src/main/java/com/oceanview/hotel/dao/DBConnection.java`:

```java
private static final String DB_URL = "jdbc:mysql://127.0.0.1:3306/oceanviewresort_hms";
private static final String DB_USER = "root";
private static final String DB_PASSWORD = "your_password_here";
```

### Step 3: Build (1 minute)

```bash
cd Ocean-View-Hotel-HMS
mvn clean package
```

Expected output: `BUILD SUCCESS`

### Step 4: Deploy (1 minute)

```bash
# Copy WAR to Tomcat
cp target/oceanview-reservation-system-1.0.0.war /path/to/tomcat/webapps/

# Start Tomcat
/path/to/tomcat/bin/startup.sh  # Linux/Mac
# OR
C:\path\to\tomcat\bin\startup.bat  # Windows
```

### Step 5: Access (30 seconds)

Open browser: http://localhost:8080/oceanview-reservation-system-1.0.0/

**Login:**
- Username: `admin`
- Password: `admin123`

---

## Troubleshooting

**Build fails?**
```bash
mvn clean install -U
```

**Can't connect to DB?**
- Check MySQL is running: `sudo systemctl status mysql`
- Verify credentials in DBConnection.java
- Test connection: `mysql -u root -p oceanviewresort_hms`

**Tomcat not deploying?**
- Check logs: `tail -f /path/to/tomcat/logs/catalina.out`
- Verify port 8080 is free: `lsof -i :8080` (Mac/Linux) or `netstat -ano | findstr :8080` (Windows)

**404 Error?**
- Wait 30 seconds for deployment to complete
- Check correct URL with context path
- Verify WAR file was extracted in webapps directory

---

## Default Credentials

**Admin Account:**
- Username: admin
- Password: admin123

**Database:**
- Host: localhost:3306
- Database: oceanviewresort_hms
- User: root
- Password: (your MySQL root password)

---

## Verify Installation

Test these features after login:

1. **Dashboard** - Shows statistics
2. **Reservations** - Create a test booking
3. **Rooms** - View room list
4. **Billing** - Generate a bill
5. **Staff** (admin) - Create a staff account
6. **Reports** - Generate a date range report

---

## Project Structure

```
Ocean-View-Hotel-HMS/
├── src/main/java/com/oceanview/hotel/
│   ├── controller/     # Servlets (MVC Controllers)
│   ├── service/        # Business Logic
│   ├── dao/            # Database Access
│   ├── model/          # Entity Classes
│   ├── util/           # Helper Classes
│   └── observer/       # Event Notification System
├── src/main/webapp/
│   ├── WEB-INF/view/   # JSP Pages
│   └── WEB-INF/web.xml # Web Configuration
├── pom.xml             # Maven Configuration
└── database_schema.sql # Database Setup Script
```

---

## Common Commands

```bash
# Build without tests
mvn clean package -DskipTests

# Run tests only
mvn test

# Clean build artifacts
mvn clean

# View dependencies
mvn dependency:tree

# Start Tomcat (background)
catalina.sh start  # Linux/Mac
catalina.bat start # Windows

# Stop Tomcat
catalina.sh stop   # Linux/Mac
catalina.bat stop  # Windows

# Watch Tomcat logs
tail -f $CATALINA_HOME/logs/catalina.out  # Linux/Mac
```

---

## Important Files

| File | Purpose |
|------|---------|
| `pom.xml` | Maven dependencies and build config |
| `DBConnection.java` | Database connection settings |
| `web.xml` | Web application configuration |
| `database_schema.sql` | Complete database schema |
| `SETUP_GUIDE.md` | Detailed setup instructions |
| `USER_GUIDE.md` | End-user documentation |

---

## Key Features

- **Reservation Management** - Booking, check-in/out, cancellation
- **Room Management** - CRUD operations for rooms
- **Billing System** - Dynamic pricing with strategies
- **Staff Management** - User account administration
- **Reports** - Occupancy and revenue analytics
- **System Logs** - Audit trail for all activities
- **Role-Based Access** - Admin vs Staff permissions

---

## Tech Stack

- **Backend:** Java 17, Servlets, JDBC
- **Frontend:** JSP, JSTL, Bootstrap
- **Database:** MySQL 8.0
- **Server:** Apache Tomcat 9
- **Build:** Maven
- **Security:** BCrypt password hashing
- **Design Patterns:** DAO, Singleton, Factory, Strategy, Observer

---

## Production Considerations

Before deploying to production:

1. Change default admin password
2. Use environment variables for DB credentials
3. Enable HTTPS/SSL
4. Configure firewall rules
5. Set up automated backups
6. Configure email SMTP settings
7. Review and adjust session timeout
8. Enable access logging
9. Set up monitoring and alerts
10. Document any custom configurations

---

## Getting Help

- **Detailed Setup:** See SETUP_GUIDE.md
- **User Manual:** See USER_GUIDE.md
- **UML Diagrams:** See uml/ directory
- **Design Patterns:** See DESIGN_PATTERNS.md (if available)

---

## System Requirements

**Minimum:**
- 2 CPU cores
- 4 GB RAM
- 2 GB disk space
- Java 17
- MySQL 8.0

**Recommended:**
- 4+ CPU cores
- 8 GB RAM
- 10 GB disk space (for logs and backups)
- SSD storage
- Dedicated database server

---

## Port Configuration

Default ports used:
- **Tomcat:** 8080
- **MySQL:** 3306
- **Tomcat Shutdown:** 8005
- **Tomcat AJP:** 8009

To change Tomcat port, edit `$CATALINA_HOME/conf/server.xml`

---

## Next Steps

1. Change admin password immediately
2. Create staff accounts
3. Add actual room inventory
4. Configure pricing strategies
5. Test all features thoroughly
6. Set up regular database backups
7. Review system logs regularly
8. Train staff on system usage

---

**Version:** 1.0.0  
**Last Updated:** March 2026

For issues or questions, refer to the detailed SETUP_GUIDE.md or contact your system administrator.

