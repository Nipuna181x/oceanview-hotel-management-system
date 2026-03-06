# Ocean View Hotel Management System

A comprehensive web-based hotel management system built with Java EE, designed to streamline hotel operations including reservations, room management, billing, and reporting.

---

## Overview

The Ocean View Hotel Management System is an enterprise-grade application that helps hotel staff manage daily operations efficiently. It provides a complete solution for handling guest reservations, room inventory, billing with dynamic pricing, staff management, and business analytics.

**Key Features:**
- Guest reservation management with check-in/check-out
- Room inventory and availability tracking
- Dynamic billing with multiple pricing strategies
- Staff account management with role-based access control
- Occupancy and revenue reporting
- Comprehensive audit logging
- Email notification system
- Responsive web interface

---

## Technology Stack

**Backend:**
- Java 17
- Jakarta Servlet API 4.0
- JDBC for database access
- Jersey (JAX-RS) for REST APIs
- BCrypt for password security

**Frontend:**
- JSP (JavaServer Pages)
- JSTL (JSP Standard Tag Library)
- Bootstrap 5 for responsive UI
- JavaScript for client-side interactions

**Database:**
- MySQL 8.0
- Stored procedures for complex operations

**Build & Deployment:**
- Apache Maven for dependency management
- Apache Tomcat 9.x application server
- WAR packaging

**Design Patterns:**
- DAO (Data Access Object)
- Singleton
- Factory
- Strategy (for pricing)
- Observer (for notifications)

---

## Documentation

- **[QUICKSTART.md](QUICKSTART.md)** - Quick 5-minute setup for experienced developers
- **[SETUP_GUIDE.md](SETUP_GUIDE.md)** - Comprehensive installation and deployment guide
- **[USER_GUIDE.md](USER_GUIDE.md)** - End-user manual for hotel staff
- **[database_schema.sql](database_schema.sql)** - Complete database schema with sample data

---

## Getting Started

### Prerequisites

Ensure you have the following installed:
- Java Development Kit (JDK) 17 or higher
- Apache Maven 3.6+
- MySQL Server 8.0+
- Apache Tomcat 9.x

### Quick Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd Ocean-View-Hotel-HMS
   ```

2. **Set up the database:**
   ```bash
   mysql -u root -p < database_schema.sql
   ```

3. **Configure database connection:**
   Edit `src/main/java/com/oceanview/hotel/dao/DBConnection.java`
   ```java
   private static final String DB_PASSWORD = "your_password";
   ```

4. **Build the project:**
   ```bash
   mvn clean package
   ```

5. **Deploy to Tomcat:**
   ```bash
   cp target/oceanview-reservation-system-1.0.0.war $CATALINA_HOME/webapps/
   ```

6. **Access the application:**
   ```
   http://localhost:8080/oceanview-reservation-system-1.0.0/
   ```

7. **Login with default credentials:**
   - Username: `admin`
   - Password: `admin123`

For detailed instructions, see [SETUP_GUIDE.md](SETUP_GUIDE.md).

---

## Project Structure

```
Ocean-View-Hotel-HMS/
├── src/
│   ├── main/
│   │   ├── java/com/oceanview/hotel/
│   │   │   ├── controller/          # Servlet controllers (MVC)
│   │   │   ├── service/             # Business logic layer
│   │   │   ├── dao/                 # Data access layer
│   │   │   ├── model/               # Entity/POJO classes
│   │   │   ├── util/                # Utility classes
│   │   │   └── observer/            # Event notification system
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   ├── view/            # JSP pages
│   │       │   └── web.xml          # Web configuration
│   │       └── index.jsp            # Landing page
│   └── test/
│       └── java/com/oceanview/hotel/  # Unit tests
├── target/                           # Build output
├── pom.xml                          # Maven configuration
├── database_schema.sql              # Database setup script
├── README.md                        # This file
├── SETUP_GUIDE.md                   # Installation guide
├── QUICKSTART.md                    # Quick setup guide
└── USER_GUIDE.md                    # User documentation
```

---

## Core Features

### 1. Reservation Management
- Create, view, and manage guest reservations
- Unique reservation number generation
- Check-in and check-out processing
- Reservation cancellation
- Status tracking (Confirmed, Checked In, Checked Out, Cancelled)

### 2. Room Management
- Add, edit, and delete rooms
- Room type categorization (Single, Double, Suite, Deluxe)
- Availability tracking
- Room rate management
- Automatic availability updates based on reservations

### 3. Billing System
- Automatic bill generation based on stays
- Dynamic pricing with multiple strategies
- Tax calculation
- Bill history and archiving
- PDF-ready bill view

### 4. Pricing Strategies
- Standard rates
- Weekend surcharges
- Holiday premiums
- Early bird discounts
- Extended stay discounts
- Group booking discounts

### 5. Staff Management (Admin Only)
- Create and manage staff accounts
- Role-based access control (Admin/Staff)
- Password security with BCrypt hashing
- Staff activity tracking

### 6. Reporting & Analytics
- Occupancy reports by date range
- Revenue analysis
- Room-wise performance metrics
- Report history archiving
- Export capabilities

### 7. System Logging
- Comprehensive audit trail
- User activity tracking
- IP address logging
- Action timestamps
- Security monitoring

---

## User Roles

### Administrator
Full system access including:
- All reservation operations
- Room management (add/edit/delete)
- Staff account management
- Pricing strategy configuration
- System logs access
- All reports

### Staff
Operational access including:
- Reservation management
- Check-in/check-out processing
- Bill generation
- View reports
- View room inventory

---

## Security Features

- BCrypt password hashing (10 rounds)
- Role-based access control
- Session management with timeout
- SQL injection prevention via prepared statements
- CSRF protection
- Input validation and sanitization
- Secure password requirements
- Activity logging for audit trails

---

## Database Schema

The system uses 8 main tables:
- **users** - Admin and staff accounts
- **rooms** - Hotel room inventory
- **guests** - Guest information
- **reservations** - Booking records
- **pricing_rates** - Dynamic pricing strategies
- **bills** - Invoices and billing records
- **system_logs** - Audit trail
- **report_history** - Generated reports archive

See [database_schema.sql](database_schema.sql) for complete schema.

---

## API Endpoints

The system uses servlet-based routing:

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/login` | GET/POST | User authentication |
| `/logout` | GET | Session termination |
| `/dashboard` | GET | Dashboard view |
| `/reservations` | GET | List all reservations |
| `/reservations/new` | GET/POST | Create reservation |
| `/reservations/{id}` | GET | View reservation details |
| `/rooms` | GET | List all rooms |
| `/rooms/new` | GET/POST | Add new room (admin) |
| `/billing` | GET | List all bills |
| `/billing/generate` | GET/POST | Generate new bill |
| `/staff` | GET/POST | Staff management (admin) |
| `/pricing` | GET/POST | Pricing strategies (admin) |
| `/reports` | GET/POST | Generate reports |
| `/help` | GET | Help documentation |

---

## Design Patterns Used

### 1. DAO (Data Access Object)
Separates database operations from business logic.
- `RoomDAO`, `ReservationDAO`, `UserDAO`, etc.

### 2. Singleton
Ensures single database connection instance.
- `DBConnection` class

### 3. Factory
Creates database connection instances.
- `DBConnectionFactory` class

### 4. Strategy Pattern
Implements dynamic pricing algorithms.
- `PricingRateService` with multiple strategies

### 5. Observer Pattern
Event-driven notifications for system actions.
- `EventManager`, `EmailNotificationListener`

### 6. MVC (Model-View-Controller)
Separates concerns for maintainability.
- Controllers: Servlets
- Models: POJO classes
- Views: JSP pages

---

## Building and Testing

### Build Commands

```bash
# Clean and build
mvn clean package

# Build without tests
mvn clean package -DskipTests

# Run tests only
mvn test

# Clean artifacts
mvn clean

# View dependency tree
mvn dependency:tree
```

### Running Tests

```bash
# Run all tests
mvn test

# Run specific test class
mvn test -Dtest=ReservationValidatorTest

# Run with coverage
mvn clean test jacoco:report
```

---

## Deployment

### Development Environment

1. Build WAR file: `mvn clean package`
2. Deploy to Tomcat: Copy WAR to `webapps/`
3. Start Tomcat: `catalina.sh start`
4. Access: `http://localhost:8080/oceanview-reservation-system-1.0.0/`

### Production Environment

For production deployment:
1. Use environment variables for sensitive data
2. Enable SSL/HTTPS
3. Configure firewall rules
4. Set up automated backups
5. Configure monitoring and logging
6. Use connection pooling
7. Optimize JVM settings
8. Implement load balancing (if needed)

See [SETUP_GUIDE.md](SETUP_GUIDE.md) for detailed production checklist.

---

## Configuration

### Database Configuration

Edit `src/main/java/com/oceanview/hotel/dao/DBConnection.java`:

```java
private static final String DB_URL = "jdbc:mysql://127.0.0.1:3306/oceanviewresort_hms";
private static final String DB_USER = "root";
private static final String DB_PASSWORD = "your_password";
```

### Email Configuration

Edit `src/main/java/com/oceanview/hotel/util/EmailUtil.java` for SMTP settings.

### Session Timeout

Default: 30 minutes. Modify in `web.xml` if needed.

---

## Troubleshooting

### Common Issues

**Build Fails:**
- Verify JDK 17 is installed and JAVA_HOME is set
- Run `mvn clean install -U` to update dependencies
- Check internet connection for Maven downloads

**Database Connection Error:**
- Verify MySQL is running
- Check credentials in DBConnection.java
- Ensure database exists: `SHOW DATABASES;`
- Check firewall allows port 3306

**404 Error:**
- Wait 30 seconds for full deployment
- Verify correct URL with context path
- Check Tomcat logs: `catalina.out`

**Login Fails:**
- Verify admin user exists in database
- Regenerate password hash if needed
- Check application logs for errors

See [SETUP_GUIDE.md](SETUP_GUIDE.md) for more troubleshooting tips.

---

## Contributing

To contribute to this project:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes
4. Write or update tests
5. Ensure all tests pass: `mvn test`
6. Commit your changes: `git commit -am 'Add feature'`
7. Push to the branch: `git push origin feature-name`
8. Submit a pull request

---

## Testing

The project includes unit tests for core functionality:
- Reservation validation
- Pricing calculations
- User authentication
- Data access operations

Run tests with: `mvn test`

---

## Performance Considerations

- Database connection pooling for scalability
- Prepared statements for query optimization
- Session management for concurrent users
- Lazy loading for large datasets
- Indexed database columns for fast queries

---

## Future Enhancements

Planned features for future versions:
- Online guest portal for self-service booking
- Payment gateway integration
- Housekeeping management module
- Inventory management
- Mobile application
- Multi-language support
- Advanced analytics dashboard
- Integration with channel managers
- SMS notifications

---

## License

This project is for educational and demonstration purposes. Modify as needed for your use case.

---

## Support

For questions or issues:
- Check the documentation files
- Review troubleshooting section in SETUP_GUIDE.md
- Check Tomcat and application logs
- Verify database connectivity

---

## Acknowledgments

Built using:
- Java EE technologies
- Apache Tomcat
- MySQL
- Maven
- Bootstrap
- BCrypt

---

## Version History

**Version 1.0.0** (March 2026)
- Initial release
- Complete reservation management system
- Room inventory management
- Dynamic billing with pricing strategies
- Staff management
- Reporting and analytics
- System logging

---

## Contact

For technical support or inquiries, contact your system administrator.

---

**Note:** This is a complete hotel management solution suitable for small to medium-sized hotels. For enterprise deployments, consider additional security hardening and scalability optimizations.

