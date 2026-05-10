<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
session_start();
$user = isset($_SESSION['user']) ? (object)$_SESSION['user'] : null;
require_once './config.php';