var mysql = require('mysql');

const mysql_host = process.env.MYSQL_HOST || '127.0.0.1';
const mysql_user = process.env.MYSQL_USER || 'root';
const mysql_pass = process.env.MYSQL_PASS || 'secret';
const mysql_db = process.env.MYSQL_DB || 'mydb';

var conn = mysql.createConnection({
  host: mysql_host, //'127.0.0.1', // host: '172.17.0.2', // '127.0.0.1', // Replace with your host name
  user: mysql_user, // 'root',      // Replace with your database username
  password: mysql_pass, // 'secret',      // Replace with your database password
  database: mysql_db // 'mydb' // // Replace with your database Name
}); 
conn.connect(function(err) {
  if (err) throw err;
  console.log('Database is connected successfully !');
});
module.exports = conn;
