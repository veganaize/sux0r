{capture name=header}

{/capture}{strip}
{$r->assign('header', $smarty.capture.header)}
{include file=$r->xhtml_header}{/strip}

<div id="proselytizer"><div id="middle">

<h1>{$r->gtext.pw_failure}</h1>
<p>{$r->gtext.pw_failure_2}</p>

<p><a href="{$r->makeUrl('/user/reset')}">{$r->gtext.pw_failure_3} &raquo;</a>

</div></div>

{include file=$r->xhtml_footer}