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

        \Model\UserRepository::AddUser('Francesco','Mannozzi', 'tonno');
        echo $template->render('index');
        exit(0);
    }
}

$displayed_name = $user['nome'] . ' ' . $user['cognome'];

echo $template->render('index', [
    'displayed_name' => $displayed_name
]);