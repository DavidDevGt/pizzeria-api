<?php

require_once __DIR__ . '/../../../config/database.php';

class Employee {
    private $db;
    private $table = 'employees';
    
    public function __construct() {
        $this->db = new Database();
    }

}