<?php

require_once 'vendor/autoload.php';
require_once 'conf/config.php';

use League\Plates\Engine;
use Util\Authenticator;

$template = new Engine('templates','tpl');
var_dump($_POST);

if (isset($_POST['password'])){

}

//Fa partire il processo di autenticazione
$user = Authenticator::getUser();

$password = '';
$password = \Model\UserRepository::GeneratePsw();


if (isset($_GET['action'])){
    if (($_GET['action']) == 'logout'){
        Authenticator::logout();
        echo $template->render('login');
        exit(0);
    }
    if (($_GET['action']) == 'new_user'){
        $name = $_POST['firstName'];
        $surname = $_POST['lastName'];
        \Model\UserRepository::AddUser($name,$surname, $password);
        echo $template->render('login');
        exit(0);
    }
    if (($_GET['action']) == 'generator'){

        echo $template->render('generator', [
            'password' => $password
            ]
        );
        exit(0);
    }
    if (($_GET['action']) == 'Authorization'){
        echo $template->render('Access', [
        ]);
    }
}

echo $template->render('login', [
]);