{capture name=header}

    <style type="text/css">
    label {ldelim}
        float: left;
        width: 140px;
        margin-right: 0.5em;
        padding-top: 0.2em;
        text-align: right;
    {rdelim}
    </style>

{/capture}{strip}
{$r->assign('header', $smarty.capture.header)}
{include file=$r->xhtml_header}{/strip}

<div id="proselytizer">

{* Header *}
<div id="header">
    {insert name="userInfo"}
</div>
<div class="clearboth"></div>

{* Content *}
<div id="middle">

<fieldset>
<legend>{$r->text.reset}</legend>

<form action="{$r->text.form_url}" name="default" method="post" accept-charset="utf-8">
<input type="hidden" name="token" value="{$token}" />

{if $validate.default.is_error !== false}
<p class="errorWarning">{$r->text.form_error} :</p>
{elseif $r->detectPOST()}
<p class="errorWarning">{$r->text.form_problem} :</p>
{/if}

<p>
<label>&nbsp;</label>
<strong>{$r->text.reset_2}</strong>
</p>

<p>
{strip}
    {capture name=error}
    {validate id="user" message=$r->text.form_error_16}
    {validate id="user2" message=$r->text.form_error_17}
    {/capture}
{/strip}

<label {if $smarty.capture.error}class="error"{/if}>{$r->text.nickname_or_email} :</label>
<input type="text" name="user" value="{$user}" />
{$smarty.capture.error}
</p>

<p>
{strip}
    {capture name=error}
    {validate id="captcha" message=$r->text.form_error_11}
    {/capture}
{/strip}
<label {if $smarty.capture.error}class="error"{/if} >{$r->text.captcha} :</label>
<input type="text" name="captcha" />
{$smarty.capture.error}
</p>

<p>
<label>&nbsp;</label>
<img src="{$r->url}/modules/captcha/getImage.php" alt="Captcha" />
</p>

<p>
<input type="button" class="button" value="{$r->text.cancel}" onclick="document.location='{$r->text.back_url}';" />
<input type="submit" value="{$r->text.submit}" class="button" />
</p>

</form>

</fieldset>

</div>

</div>

{include file=$r->xhtml_footer}