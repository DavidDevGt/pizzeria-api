<?php

require_once __DIR__ . '/../../../config/database.php';

class Order {
    private $db;
    private $table = 'orders';
    
    public function __construct() {
        $this->db = new Database();
    }

}