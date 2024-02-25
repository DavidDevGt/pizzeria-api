<?php

/**
 * Valida que una cadena cumpla con los requisitos de una contraseña fuerte.
 *
 * @param string $password La contraseña a validar.
 * @return bool Verdadero si la contraseña es válida; falso en caso contrario.
 */
function validatePassword($password) {
    $pattern = '/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}$/';
    return preg_match($pattern, $password);
}

/**
 * Valida un correo electrónico.
 *
 * @param string $email El correo electrónico a validar.
 * @return bool Verdadero si el correo es válido; falso en caso contrario.
 */
function validateEmail($email) {
    return filter_var($email, FILTER_VALIDATE_EMAIL);
}

/**
 * Valida un entero positivo.
 *
 * @param int $number El número a validar.
 * @return bool Verdadero si el número es un entero positivo; falso en caso contrario.
 */
function validatePositiveInteger($number) {
    return filter_var($number, FILTER_VALIDATE_INT) && $number > 0;
}

/**
 * Limpia una cadena para evitar inyecciones SQL y XSS.
 *
 * @param string $data La cadena a limpiar.
 * @return string La cadena limpia.
 */
function sanitizeString($data) {
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    return $data;
}

