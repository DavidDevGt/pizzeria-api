<?php

require_once __DIR__ . '/../../../config/database.php';

class Delivery {
    private $db;
    private $table = 'deliveries';
    
    public function __construct() {
        $this->db = new Database();
    }

}