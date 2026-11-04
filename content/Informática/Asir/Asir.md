¡Hola Alberto! Si es que eres tú el que está viendo esto...

Estás presenciando una pequeña parte de mi jardín digital, en este caso, todo lo referente a 2º de ASIR. Estoy intentando subir el curso entero, pero estoy sufriendo algunas dificultades.

Navegar por la bóveda puede ser complicado, por lo que añadiré ciertos enlaces de interés, que llevan a lugares más interesantes, como las propias tareas y apuntes.

- [[Administración de sistemas gestores de bases de datos]].
- [[Administración de sistemas operativos]].
- [[Digitalización]].
- [[Inglés profesional]].
- [[Itinerario para la empleabilidad II]].
- [[Implantación de aplicaciones web]].
- [[Programación en Python]].
- [[Servicios de red e internet]].
- [[Seguridad y alta disponibilidad]].

Este índice está pensado para que los visitantes, pero especialmente Alberto, puedan navegar fácilmente, por lo que cualquier cambio sugerido será implementado.

# Global

Link: [GLOBAL_EPORFOLIO](https://docs.google.com/document/d/16uF3n2ZZuATHib7g_Iij5DLrOl2-3fCPi0DOAz2oOpU/edit?tab=t.0).

## [[Administración de sistemas gestores de bases de datos|ASGBD]]

### [[1.2 DBA de MySQL|DBA_MYSQL_RA12]]

1. Resume.
	1. Case 1: A high-concurrency e-commerce system needing real-time responses and strong transaction integrity.
	2. Case 2: A data-warehouse environment focused on heavy, repetitive analytical queries over large historical datasets, with low concurrency.
	3. Case 3: A social-network platform with very high read activity, moderate concurrency, and occasional writes, prioritizing fast profile/content retrieval.
2. Difficulty concepts.
	1. Understanding the impact of memory-allocation parameters (buffer pool, caches).
	2. Balancing durability vs performance (`innodb_flush_log_at_trx_commit`).
3. Feelings: A little bit tired, I think that this work is sometimes decontextualize compared than a real database.
4. Upgrading.
	1. Reassess cache and buffer sizes based on real monitoring metrics instead of fixed percentages.
	2. Use `performance_schema` only during tuning.
	3. Enable binary logging for safer recovery (even with low write workloads).
	4. Avoid extremely high `max_connections`; scale via connection pooling instead.
5. Glossary words.
	1. Transaction: A group of operations executed as a single, atomic unit.
	2. Concurrency: Number of users or processes accessing the database simultaneously.
	3. Cache: Memory used to store frequently accessed data for faster retrieval.
	4. Durability: Guarantee that committed data persists even after failures.
	5. Aggregation query: A query that calculates summaries (SUM, COUNT, AVG, etc.).
6. Calificación for heading: I think that the interview could be wrote instead of talked, but is nice in this case. 8/10.

### [[1.4 Usuarios y permisos de MySQL|Usuarios y permisos de MySQL]]

1. Resume.
	1. The task focuses on creating and managing MySQL users and permissions within a simple "social network" database composed of three tables: _usuario_, _grupo_, and _comentario_. It includes creating users with specific host restrictions, modifying passwords, displaying current users, and assigning or revoking privileges such as `SELECT`, `UPDATE`, `DELETE`, or `ALL PRIVILEGES`. The student must also connect as different users to test allowed and denied actions, modify privileges using both `GRANT/REVOKE` and direct updates to the `mysql.user` table, and understand the use of `FLUSH PRIVILEGES`.
2. Difficulty concepts.
	1. The effect of `GRANT OPTION` and privilege inheritance.
	2. Risks and limitations of modifying `mysql.user` directly.
3. Feelings: I feel good, this is a great task.
4. Upgrading.
	1. Role-based privilege management using MySQL roles.
	2. Password expiration policies and account locking.
	3. Logging failed logins and auditing privilege changes.
	4. Creating stored procedures to automate privilege assignment.
5. Glossary words.
	1. Privilege: A specific permission granted to a MySQL user.
	2. Host: The machine or domain from which a user is allowed to connect.
	3. GRANT OPTION: Allows a user to grant their own privileges to others.
	4. Flush: Reloads MySQL privilege tables into memory.
	5. Revoke: Removes previously granted permissions.
6. Calificación for heading: Very good all things. 10/10.

### [[2.2 DBA de SQLite|DBA de SQLite]]

1. Resume.
	1. This activity describes how to manage and configure an SQLite database for a small fruit-management application. It covers database setup, table creation with constraints, performance optimization through indexing and `PRAGMA` configuration, disk-space considerations, backup/restore procedures, automation with cron jobs, and security best practices.
2. Difficulty concepts.
	1. Understanding how SQLite handles file size vs. logical size.
	2. Automating backups securely with bash scripts and cron.
3. Feelings: Excited, I like a lot SQLite3, and is very easy to me.
4. Upgrading.
	1. Normalize tables further to avoid redundant data.
	2. Add more specific indexes (on frequently queried columns like _color_, _tamaño_).
	3. Enable WAL mode for simultaneous reads/writes.
	4. Implement encryption for sensitive data.
	5. Improve the backup script to include timestamps or compression.
5. Glossary words.
	1. PRAGMA: SQLite command used to modify internal database settings.
	2. WAL (Write-Ahead Logging): Journaling mode improving concurrency and safety.
	3. Index: Structure that accelerates searches on specific columns.
	4. Cron job: Scheduled automated task in Unix systems.
	5. Foreign key: Constraint linking a row to another table.
6. Calificación for heading: Very interesting the `cron` part. 10/10.

### [[3.2 DBA de PostgreSQL|DBA de PostgreSQL]]

1. Resume.
	1. This task covers the full workflow of installing and managing PostgreSQL on Linux: installation, service setup, and access through the `postgres` user. It includes creating a database ("EquitacionSuave"), defining structured tables (_jinetes_ and _caballos_), and managing user roles with different permissions. It also involves inserting, querying, updating, and deleting data, as well as administering the database visually using pgAdmin.
2. Difficulty concepts.
	1. Correct creation and use of ENUM types.
	2. JSONB manipulation and proper casting.
3. Feelings: Strange, PostgreSQL is rarely in use.
4. Upgrading.
	1. Add constraints (NOT NULL, CHECK, UNIQUE).
	2. Implement indexing for faster joins.
	3. Create stored procedures or triggers (e.g., auto-update experience level).
	4. Normalize the schema further (e.g., separate horse breeds).
	5. Add backups and basic security hardening steps.
5. Glossary words.
	1. ENUM: A fixed set of predefined values.
	2. JSONB: Binary JSON type optimized for indexing and queries.
	3. ARRAY: A column storing lists of values.
	4. Foreign key: A reference ensuring relational integrity.
	5. Materialized view: A stored query result that must be manually refreshed.
6. Calificación for heading: Good task to learn basic management of PostgreSQL. 8/10.

## Exam

1. Resume.
	1. We need to do a exam about the all the homework of [[Administración de sistemas gestores de bases de datos|ASGBD]].
2. Difficulty concepts.
	1. The exactly syntax of SQL queries.
	2. Some specifically questions.
3. Feelings: Normal.
4. Calificación for heading: Normal exam, I think that the teacher do it with ChatGPT. 6/10.

## [[Implantación de aplicaciones web|IAW]]

### [[1.1 Extensiones para PHP|EXTENSIONES_VSC_IAW_RA1]]

1. Resume.
	1. _PHP Intelephense_ provides core language support such as autocompletion and error checking, and requires a PHP interpreter like XAMPP or WampServer. _PHP Debug_ enables debugging features, using tools such as Xdebug. _PHP Snippets_ adds predefined code snippets to speed up PHP development.
2. Difficulty concepts.
	1. Understanding why Intelephense requires an external PHP interpreter.
	2. Knowing how PHP Debug interacts with Xdebug.
3. Feelings: Normal, is not excited activity.
4. Upgrading.
	1. To improve the workflow, install Intelephense alongside a correctly configured PHP environment. Add Xdebug to enable PHP Debug. Customize or create snippets to match common coding patterns. Keep all extensions updated for better performance and compatibility.
5. Glossary words.
	1. Interpreter: Software that executes code line by line.
	2. Debugging: Process of finding and fixing errors in code.
	3. Snippets: Predefined blocks of reusable code.
	4. Autocompletion: Automatic suggestion of code elements while typing.
	5. Extension: Add-on that enhances editor functionality.
6. Calificación for heading: Is a normal activity, and good for introduction. 7/10.

### [[2.1 Dados y formulario|DA2_RA15]]

1. Resume.
	1. The work consist in create a web page using PHP where the user puts numbers and PHP code create, stealing to an other site, the dices to show.
2. Difficulty concepts.
	1. POST events and their management.
	2. Choosing the correct dice and center text on.
3. Feelings: A little bit tired, I think that this work is sometimes decontextualize compared than a real database.
4. Upgrading.
	1. Creating a more visual index.php login. The actual is very simple and not use CSS.
	2. I could center better the numbers in the dices, but it work is very difficult.
5. Glossary words.
	1. POST: Method to pass arguments to different web pages.
	2. Dictionary: Structure that admit keys and values.
6. Calificación for heading: I think that the use of dices is excessive and so restrictive to the creativity of students. Boring and very less efficiency. 4/10.

### [[4.2 Resumen de MongoDB|Resumen de MongoDB]]
1. Resume.
    1. This task is a deep dive into MongoDB, a NoSQL database that uses JSON and JavaScript. It includes creating collections for a commerce system (users, products, orders) and performing advanced queries and joins. It also uses MongoDB Compass as a visual client.
2. Difficulty concepts.
    1. Using JavaScript logic to implement features that are not native in the tables.
    2. Understanding how to do "joins" in a system that is not relational.
3. Feelings: Excited, MongoDB feels very modern and fast compared to SQL.
4. Upgrading.
    1. Use more aggregation pipelines for complex data analysis.
    2. Explore more options in MongoDB Compass.
5. Glossary words.
    1. JSON: Format used for data exchange based on JavaScript.
    2. Collection: The NoSQL equivalent of a table.
    3. Concurrency: Multiple users accessing the data at the same time.
    4. Compass: Graphic interface to manage MongoDB.
6. Calificación for heading: Very complete task to understand the NoSQL world. 10/10.
### [[3.1 Juego con base de datos|Juego con base de datos]]

1. Resume.
    1. This task consist in create a complete database with tables and data based on a schema, and then use PHP and CSS to create a game logic.
2. Difficulty concepts.
    1. Connect the PHP code with the SQL database and index the results correctly.
3. Feelings: Normal, but it's good to see how a database works with a real (simple) application.
4. Upgrading.
    1. Use more CSS to make the game looks better.
    2. Add more complex queries to the database.
5. Glossary words.
    1. Schema: The structure and design of the database.
    2. Index: Sorting and organizing data for faster access.
6. Calificación for heading: Good work to practice the connection between PHP and MySQL. 8/10.

### [[5.1 Instalación y configuración mínima de Redis|Instalación y configuración mínima de Redis]]
1. Resume.
    1. This activity covers how to install Redis, connect it with PHP, and manage different data types like simple keys, lists, hashes, and sets. It also shows how to use RedisInsight for visual management and how to make snapshots of the database.
2. Difficulty concepts.
    1. The installation of the PHP extension, especially if the primary option fails.
    2. Understanding atomic increments and how to manage memory like in Rust.
3. Feelings: Good, Redis is very fast and the commands are simple to remember.
4. Upgrading.
    1. Implement Sorted Sets for more complex rankings.
    2. Use JSON serialization instead of just plain text.
5. Glossary words.
    1. Hash: A dictionary-like structure with field-value pairs.
    2. Snapshot: A backup of the database at a specific moment.
    3. Atomic: An operation that happens completely or not at all, with no middle state.
    4. RedisInsight: Visual tool to see the Redis data.
6. Calificación for heading: Very good for learning about cache and fast data structures. 9/10.

### [[4.1 Implementación de PHP con Redis y MySQL|Implementación de PHP con Redis y MySQL]]

1. Resume.
    1. The goal is to manage a system for olives with "vareadores" and "olivos" using a N:M relation. It uses MySQL for the main tables and Redis to support the system without complex NoSQL management.
2. Difficulty concepts.
    1. Managing the N:M relationship in the PHP code and the join table.
3. Feelings: A little bit strange because the topic of olives is funny, but the task is serious.
4. Upgrading.
    1. Implement more NoSQL features directly in Redis instead of just supporting MySQL.
5. Glossary words.
    1. N:M relation: When many elements of one table relate to many of another.
    2. NoSQL: Database system that does not use traditional tables.
6. Calificación for heading: Interesting mix of SQL and NoSQL. 7/10.
## Exam

1. Resume.
	1. We need to do a exam about the all the homework of [[Implantación de aplicaciones web|IAW]].
2. Difficulty concepts.
	1. Anything, I am good in PHP.
3. Feelings: Excited.
4. Calificación for heading: Easy exam, I think that the teacher do it with ChatGPT. 8/10.

## [[Seguridad y alta disponibilidad|SAD]]

### [[1.1 Ataque de diccionario|ATTACK_SIMULATION_RA12]]

1. Resume.
	1. The text explains how to perform brute‑force attacks using Hydra by generating password dictionaries with Pydictor, optionally merging them with Dymerge, and then applying them to SSH and web login forms. It also includes installation steps for SSH on Kali Linux and instructions to set up a vulnerable DVWA web server on XAMPP for testing.
2. Difficulty concepts.
	1. Understanding SSH service setup and troubleshooting.
	2. Handling Python2‑dependent tools like Dymerge.
3. Feelings: Excited, hacking is always excited.
4. Upgrading.
	- Replace Dymerge (Python2) with modern Python3 alternatives for merging wordlists.
	- Optimize wordlist generation by adding rules or filtering to reduce attack time.
	- Use `-t` threads and connection limits more efficiently in Hydra to avoid lockouts.
	- Consider using Hashcat or other GPU‑based tools for faster password cracking when applicable.
5. Glossary words.
	- SSHSecure protocol for remote login.
	- Brute force: Trying many passwords until one works.
	- Dictionary: File containing password candidates.
	- Hydra: Password‑cracking tool for multiple protocols.
	- Pydictor: Wordlist generator supporting patterns and lengths.
	- Dymerge: Tool to merge dictionaries.
	- DVWA: Vulnerable web app for security testing.
6. Calificación for heading: Very good work, I feel excited all the time. 10/10.
### [[1.2 Práctica de permisos en Linux|COMAN2_LINUX_RA1]]

1. Resume.
	1. This task focuses on Linux file and user management, including basic commands (`ls`, `cd`, `mkdir`, `touch`), permission control (`chmod`, `chown`, `umask`), and advanced features like SGID, sticky bit, and ACLs. Users learn to manage directories, enforce collaborative permissions, and secure files in multi-user environments. The second phase emphasizes advanced file searches using `grep`, `find`, and `locate`.
2. Difficulty concepts.
	1. ACLs for fine-grained access.
	2. Recursive and conditional searches with `grep` and `find`.
3. Feelings: Normal, is a typical task about permissions and Linux commands.
4. Upgrading.
	1. Practice combining multiple permission commands.
	2. Explore `setfacl` for complex group-based permissions.
	3. Automate search tasks using pipelines and scripts.
	4. Simulate multi-user environments to reinforce collaboration rules.
5. Glossary words.
	1. SGID: Ensures new files inherit the parent directory’s group.
	2. Sticky bit: Prevents users from deleting others’ files in shared directories.
	3. umask: Default permission mask for newly created files.
	4. ACL: Access Control List, allows detailed permission settings.
	5. grep/find/locate: Commands to search file contents or filesystem structures.
6. Calificación for heading: I thinks is good work for remember Linux permissions and commands, sometimes boring, but effective in knowledge. 8/10.
### [[1.3 Usando exploits comunes|EXPLOIT_BOOM_RA123]]

1. Resume.
	1. The task consists of developing and exploiting two common web vulnerabilities: SQL Injection and Cross‑Site Scripting (XSS).
2. Difficulty concepts.
	- Understanding how SQL queries are manipulated through input concatenation.
	- Forcing Flask to become vulnerable despite its default auto‑escaping.
3. Feelings: Good and bad, because the task is very interesting, but we need to force the insecurities, and it can be complicated without enought information. ^1
4. Upgrading.
	- Use prepared statements or ORM layers (SQLAlchemy).
	- Apply output encoding in all templates.
	- Validate and sanitize user input.
	- Enable Content Security Policy (CSP) to reduce XSS impact.
5. Glossary words.
	- SQL Injection: Manipulating SQL queries through user input.
	- XSS: Injecting malicious scripts into web pages.
	- Prepared Statement: Safely parameterized SQL query.
	- Sanitization: Removing or encoding dangerous input.
	- Payload: Malicious input used to exploit vulnerabilities.
6. Calificación for heading: I say it in [[#^1|Feelings]], but is good. 8/10.

### [[1.4 Herramientas de hacking|Herramientas de hacking]]

1. Resume.
	1. The task is about three different tools for hacking and analysis: Messageheader to see email metadata, Browserling to emulate operating systems and browsers, and VirusTotal or Any.run to analyze if a file is malware.
2. Difficulty concepts.
	1. Understanding how email metadata like SPF, DKIM, and DMARC works to verify security.
	2. The difference between using a simple browser emulator and a full malware sandbox.
3. Feelings: Very good, I like to see how I can analyze suspicious files and emails.
4. Upgrading.
	1. Use more complex malware analysis tools like Any.run with a professional account.
	2. Deep dive into SMTP vulnerabilities that still exist today.
5. Glossary words.
	1. Metadata: Extra information attached to files or emails.
	2. Sandbox: Isolated environment to run suspicious programs safely.
	3. SPF/DKIM/DMARC: Protocols to verify the identity of an email sender.
	4. Emulation: Creating a virtual version of a system or browser.
6. Calificación for heading: Very useful tools for a security environment. 9/10.
## Exam

1. Resume.
	1. We need to do a exam about the all the homework of [[Seguridad y alta disponibilidad|SAD]].
2. Difficulty concepts.
	1. The specifically questions about class task. I think that a good exam can be resolved by any expert in the materia, and I think that this is not the case.
3. Feelings: Norma.
4. Calificación for heading: Normal exam, I think that the teacher do it with ChatGPT. 7/10.