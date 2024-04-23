<?php

require_once 'vendor/autoload.php';
require_once 'conf/config.php';

use League\Plates\Engine;
use Util\Authenticator;

$template = new Engine('templates','tpl');
//Fa partire il processo di autenticazione
$user = Authenticator::getUser();



if (isset($_GET['action'])){
    if (($_GET['action']) == 'logout'){
        Authenticator::logout();
        echo $template->render('login');
        exit(0);
    }
    if (($_GET['action']) == 'new_user'){
        $name = $_POST['firstName'];
        $surname = $_POST['lastName'];
        $password = $_POST['password'];
        \Model\UserRepository::AddUser($name,$surname, $password);
        echo $template->render('login');
        exit(0);
    }
    if (($_GET['action']) == 'generator'){
        echo $template->render('generator');
        exit(0);
    }

}


echo $template->render('login', [
]);