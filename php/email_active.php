<?php
// ������ ��������� �����	

$authkey = '446991035'; // ������� ��� ������ EMAIL ���������
$projectname = 'Western State'; // ��� ����
$fromemail = 'no-replay@western-state.ru.ru'; // E-Mail �� ����

if($_GET['authkey'] == $authkey and strlen($authkey)) {
	$to = strtolower(trim($_GET['email']));
	if(preg_match("/^([a-zA-Z0-9])+([\.a-zA-Z0-9_-])*@([a-zA-Z0-9_-])+(\.[a-zA-Z0-9_-]+)*\.([a-zA-Z]{2,6})$/", $to)) {
		$headers  = 'MIME-Version: 1.0' . "\r\n";
		$headers .= 'Content-type: text/html; charset=windows-1251' . "\r\n";
		$headers .= 'From: '.$projectname.' <'.$fromemail.'>' . "\r\n";
		$code = intval($_GET['code']); 
		$mess = "��� ��� ���������: $code";
		$title = '������������� E-Mail';
		if(mail($to, $title, $mess, $headers))
			exit('1');
		else
			exit('-1');
	} else exit('-1');
} else exit('-2');


// The end
?> 