# Microsoft SQL Server

## Get Evaluation period

```sql
SELECT create_date AS 'SQL Server Install Date', DATEADD(DD, 180, create_date) AS 'SQL Server Expiration Date'
FROM sys.server_principals
WHERE name = 'NT AUTHORITY\SYSTEM'
```

## Backup scripts example

- [Backup scripts example](./backup/README.md)

## Sources

- [Upgrade Microsoft SQL Server Evaluation Edition to Standard/Enterprise](https://woshub.com/upgrade-mssqlserver-evaluation-to-standard-enterprise/)
- [Check remaining time for sqlserver](https://dba.stackexchange.com/questions/284658/check-remaining-time-for-sqlserver)
