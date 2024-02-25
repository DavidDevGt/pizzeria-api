<?php

require_once __DIR__ . '/../../../config/database.php';

class Customer {
    private $db;
    private $table = 'customers';
    
    public function __construct() {
        $this->db = new Database();
    }

}