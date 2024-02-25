<?php

use Dotenv\Dotenv;

require_once __DIR__ . '/../../vendor/autoload.php';

$dotenv = Dotenv::createImmutable(__DIR__ .'/../../.env');
$dotenv->load();

class Database {
    private $host = $_ENV['DB_HOST'];
    private $user = $_ENV['DB_USER'];
    private $pass = $_ENV['DB_PASS'];
    private $dbname = $_ENV['DB_NAME'];

    private $connection;
    private $error;

    public function __construct() {
        // Conexión
        $this->connection = new mysqli($this->host, $this->user, $this->pass, $this->dbname);

        // Check Connection
        if ($this->connection->connect_error) {
            $this->error = "Fallo al conectar a MySQL: " . $this->connection->connect_error;
            return false;
        }
    }

    public function dbQuery($query) {
        $result = $this->connection->query($query);
        if (!$result) {
            $this->error = "Error al ejecutar la consulta: " . $this->connection->error;
            return false;
        }
        return $result;
    }

    public function dbFetchAssoc($result) {
        return $result->fetch_assoc();
    }

    public function dbFetchAll($result) {
        return $result->fetch_all(MYSQLI_ASSOC);
    }

    public function dbQueryInsert($table, $data) {
        $keys = implode(',', array_keys($data));
        $values = implode("','", array_values($data));
        $query = "INSERT INTO $table ($keys) VALUES ('$values')";
        $insert = $this->dbQuery($query);
        return $insert ? $this->connection->insert_id : false;
    }

    public function getError() {
        return $this->error;
    }

    public function close() {
        $this->connection->close();
    }
}