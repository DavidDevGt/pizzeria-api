<?php

require_once __DIR__ . '/../../../config/database.php';
require_once __DIR__ . '/../../../utils/helpers.php';

class User {
    private $db;
    private $table = 'users';

    public function __construct() {
        $this->db = new Database();
    }

    public function getAll() {
        $result = $this->db->dbQuery("SELECT * FROM {$this->table} WHERE active = 1");
        return $this->db->dbFetchAll($result);
    }

    public function getById($id) {
        $result = $this->db->dbQuery("SELECT * FROM {$this->table} WHERE id = $id AND active = 1");
        return $this->db->dbFetchAssoc($result);
    }

    public function create($data) {
        // Validaciones
        if (!validateEmail($data['email'])) {
            throw new Exception("Correo electrónico inválido.");
        }

        if (!validatePassword($data['password'])) {
            throw new Exception("La contraseña debe tener al menos 8 caracteres, incluyendo un número, una letra mayúscula y una minúscula.");
        }

        // Sanitización
        $data['email'] = sanitizeString($data['email']);
        $data['username'] = sanitizeString($data['username']);

        // Encriptación de la contraseña
        $data['password'] = password_hash($data['password'], PASSWORD_DEFAULT);

        // Insertar el nuevo usuario
        return $this->db->dbQueryInsert($this->table, $data);
    }

    public function update($id, $data) {
        $setPart = [];
        foreach ($data as $key => $value) {
            // Sanitización de cada valor
            $sanitizedValue = sanitizeString($value);
            $setPart[] = "$key = '$sanitizedValue'";
        }
        $setPartString = implode(', ', $setPart);
        $query = "UPDATE {$this->table} SET $setPartString WHERE id = $id AND active = 1";
        return $this->db->dbQuery($query);
    }

    public function delete($id) {
        $query = "UPDATE {$this->table} SET active = 0 WHERE id = $id";
        return $this->db->dbQuery($query);
    }
}
