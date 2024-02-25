<?php

require_once __DIR__ ."/../../config/database.php";

class User {
    private $db;

    public function __construct() {
        $this->db = new Database();
    }

    public function getAllUsers() {
        $result = $this->db->dbQuery("SELECT * FROM users");
        return $this->db->dbFetchAll($result);
    }

    public function getUserbyId($id) {
        $result = $this->db->dbQuery("SELECT * FROM users WHERE id = $id");
        return $this->db->dbFetchAssoc($result);
    }
}