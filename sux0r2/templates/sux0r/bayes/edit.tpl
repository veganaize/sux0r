{capture name=header}

    <script src="{$r->url}/includes/symbionts/scriptaculous/lib/prototype.js" type="text/javascript"></script>
    {literal}
    <script type='text/javascript'>
    // <![CDATA[

    function rm(myForm, myWarning) {
        if(confirm(myWarning)) {
            var x = document.getElementsByName(myForm);
            x[0].submit();
        }
    }

    function getDoc(doc_id) {
        if (doc_id) {
            {/literal}
            var url = '{$r->url}/modules/bayes/getDoc.php';
            {literal}
            var pars = 'id=' + doc_id;

            var myAjax = new Ajax.Updater('placeholder1', url, {
                    method: 'get',
                    parameters: pars
            });
            $('placeholder1').addClassName('active');
            $('placeholder1').show();
        }
    }

    function getCat(document, vec_id) {

        {/literal}
        var url = '{$r->url}/modules/bayes/getCat.php';
        {literal}
        var pars = { document: document, id: vec_id }

        var myAjax = new Ajax.Updater('placeholder2', url, {
                method: 'post',
                parameters: pars
        });
        $('placeholder2').addClassName('active');
        $('placeholder2').show();

    }

    // ]]>
    </script>
    {/literal}

{/capture}{strip}
{$r->assign('header', $smarty.capture.header)}
{include file=$r->xhtml_header}{/strip}

<table id="proselytizer" >
	<tr>
		<td colspan="2" style="vertical-align:top;">
			<div id="header">
            {insert name="userInfo"}
			</div>
		</td>
	</tr>
	<tr>
        <td style="vertical-align:top;">
			<div id="leftside">

    {* Content *}
    <div id="middle">

        <noscript><p class="errorWarning">JavaScript must be enabled to categorize and delete!</p></noscript>

        {if $validate.default.is_error !== false}
        <p class="errorWarning">{$r->text.form_error} :</p>
        {/if}

        <fieldset>
        <legend>Vectors</legend>

        {* Add a vector  ---------------------------------------------------- *}

        <form action="{$r->text.form_url}" name="addvec" method="post" accept-charset="utf-8">
        <input type="hidden" name="token" value="{$token}" />
        <input type="hidden" name="action" value="addvec" />

        <p>
        {strip}
            {capture name=error}
            {validate id="addvec1" form="addvec" message=$r->text.form_error_1}
            {validate id="addvec2" form="addvec" message=$r->text.form_error_5}
            {/capture}
        {/strip}

        <label for="vector" {if $smarty.capture.error}class="error"{/if} > New vector :</label>
        <input type="text" name="vector" value="{$vector}" />
        <input type="submit" class="button" value="Add" />
        {$smarty.capture.error}
        </p>

        </form>


        {* Remove a vector -------------------------------------------------- *}

        <form action="{$r->text.form_url}" name="remvec" method="post" accept-charset="utf-8">
        <input type="hidden" name="token" value="{$token}" />
        <input type="hidden" name="action" value="remvec" />

        <p>
        {strip}
            {capture name=error}
            {validate id="remvec1" form="remvec" message=$r->text.form_error_3}
            {/capture}
        {/strip}

        <label for="vector_id" {if $smarty.capture.error}class="error"{/if} > Remove vector :</label>
        {html_options name='vector_id' options=$r->getVectors() selected=$vector_id}
        <input type="button" class="button" value="Delete" onclick="rm('remvec', 'Are you sure you want to delete this vector?');" />
        {$smarty.capture.error}
        </p>

        </form>

        {* // --------------------------------------------------------------- *}

        </fieldset>


        <fieldset>
        <legend>Categories</legend>

        {* Add a category --------------------------------------------------- *}

        <form action="{$r->text.form_url}" name="addcat" method="post" accept-charset="utf-8">
        <input type="hidden" name="token" value="{$token}" />
        <input type="hidden" name="action" value="addcat" />

        <p>
        {strip}
            {capture name=error}
            {validate id="addcat1" form="addcat" message=$r->text.form_error_2}
            {validate id="addcat2" form="addcat" message=$r->text.form_error_1}
            {validate id="addcat3" form="addcat" message=$r->text.form_error_6}
            {/capture}
        {/strip}

        <label for="category" {if $smarty.capture.error}class="error"{/if} > New category :</label>
        <input type="text" name="category" value="{$category}" />
        {html_options name='vector_id' options=$r->getVectors() selected=$vector_id}
        <input type="submit" class="button" value="Add" />
        {$smarty.capture.error}
        </p>

        </form>


        {* Remove a category ------------------------------------------------ *}

        <form action="{$r->text.form_url}" name="remcat" method="post" accept-charset="utf-8">
        <input type="hidden" name="token" value="{$token}" />
        <input type="hidden" name="action" value="remcat" />

        <p>
        {strip}
            {capture name=error}
            {validate id="remcat1" form="remcat" message=$r->text.form_error_4}
            {/capture}
        {/strip}

        <label for="category_id" {if $smarty.capture.error}class="error"{/if} > Remove category :</label>
        {html_options name='category_id' options=$r->getCategories() selected=$category_id}
        <input type="button" class="button" value="Delete" onclick="rm('remcat', 'Are you sure you want to delete this category?');" />
        {$smarty.capture.error}
        </p>

        </form>


        {* // --------------------------------------------------------------- *}

        </fieldset>


        <fieldset>
        <legend>Documents</legend>


        {* Train a document -------------------------------------------------- *}

        <form action="{$r->text.form_url}" name="adddoc" method="post" accept-charset="utf-8">
        <input type="hidden" name="token" value="{$token}" />
        <input type="hidden" name="action" value="adddoc" />

        <p>
        {strip}
            {capture name=error}
            {validate id="adddoc1" form="adddoc" message=$r->text.form_error_7}
            {validate id="adddoc2" form="adddoc" message=$r->text.form_error_4}
            {/capture}
        {/strip}

        <label for="document" {if $smarty.capture.error}class="error"{/if} > Train document :</label>
        <textarea name="document" cols='50' rows='10'>{$document}</textarea><br />
        <label>&nbsp;</label>{html_options name='category_id' options=$r->getCategories() selected=$category_id}
        <input type="submit" class="button" value="Add" />
        {$smarty.capture.error}
        </p>

        </form>


        {* Untrain a document ----------------------------------------------- *}

        <form action="{$r->text.form_url}" name="remdoc" method="post" accept-charset="utf-8">
        <input type="hidden" name="token" value="{$token}" />
        <input type="hidden" name="action" value="remdoc" />

        <p>
        {strip}
            {capture name=error}
            {validate id="remdoc1" form="remdoc" message=$r->text.form_error_7}
            {/capture}
        {/strip}

        <label for="document_id" {if $smarty.capture.error}class="error"{/if} > Untrain document :</label>
        <select name="document_id" onmouseup="getDoc(this.value);">
        {html_options options=$r->getDocuments() selected=$document_id}
        </select>
        <input type="button" class="button" value="Delete" onclick="rm('remdoc', 'Are you sure you want to delete this document?');"/>
        {$smarty.capture.error}
        </p>

        <div id="placeholder1"></div>

        </form>


        {* // --------------------------------------------------------------- *}

        </fieldset>


        <fieldset>
        <legend>Categorize</legend>

        {* Categorize document ---------------------------------------------- *}

        <form action="{$r->text.form_url}" name="catdoc" method="post" accept-charset="utf-8">



        <p>
        <label for="document" >Categorize document :</label>
        <textarea name="cat_document" cols='50' rows='10'>{$cat_document}</textarea><br />
        <label>&nbsp;</label>{html_options name='vector_id' options=$r->getVectors() selected=$vector_id}
        <input type="button" class="button" value="Categorize" onclick="getCat(this.form.cat_document.value, this.form.vector_id.value);" />
        {$smarty.capture.error}
        </p>

        <div id="placeholder2"></div>



        </form>

        {* // --------------------------------------------------------------- *}


        </fieldset>


        <fieldset>
        <legend>Share</legend>

        {* TODO *}

        <p>
        <label for="vector_id">Share vector:</label>
            {html_options name='vector_id' options=$r->getVectors() selected=$vector_id}
        </p>

        <p>
        <label for="friends">With friend:</label>
            <select name="friends">
            <option value="">conner_bw</option>
            <option value="">test</option>
            <option value="">Shie Kasai</option>
            </select>
        </p>

        <p>
        <label for="trainer">&nbsp;</label>
            <input type="checkbox" name="trainer" value="1" /> Allow user to train documents?
        </p>

        <p>
        <label>&nbsp;</label>
            <input type="submit" class="button" value="Share" />
        </p>


        {* // --------------------------------------------------------------- *}


        </fieldset>

        <fieldset>
        <legend>Manage</legend>

        {* TODO *}


        <p>
        <h3>Some Title</h3>
        <table border="0" width="100%">
        <thead>
        <tr>
            <th>Vector</th>
            <th>Owner</th>
            <th>Is Trainer?</th>
            <th>Unshare</th>
        </tr>
        </thead>
        <tbody>
        <tr bgcolor="#eeeeee">
            <td>1</td>
            <td>2</td>
            <td><input type="checkbox" name="trainer[1]" value="1" /></td>
            <td><input type="checkbox" name="unshare[1]" value="1" /></td>
        </tr>
        <tr bgcolor="#dddddd">
            <td>1</td>
            <td>2</td>
            <td><input type="checkbox" name="trainer[1]" value="1" /></td>
            <td><input type="checkbox" name="unshare[1]" value="1" /></td>
        </tr>
        </tbody>
        </table>
        <center><input type="submit" class="button" value="Submit" /></center>
        </p>


        {* // --------------------------------------------------------------- *}

        </fieldset>


			</div>
		</td>
		<td style="vertical-align:top;">
			<div id="rightside">

            {capture name=stats}{$r->getCategoryStats()}{/capture}
            {if $smarty.capture.stats}
            <p>
            Stats:<br />
            {$smarty.capture.stats}
            </p>
            {/if}

            <p>Synopsis:</p>

            <p>A vector is a list of categories. You must have at least two categories
            in a vector to do <a href="http://en.wikipedia.org/wiki/Naive_Bayes_classifier">Bayesian classification</a>.</p>

            <p>For example, a vector named <strong>Feelings</strong>
            could have the categories <strong>Happy</strong>, <strong>Sad</strong> and <strong>Angry</strong>.
            A vector named <strong>Filter</strong> could have the categories <strong>Spam</strong>
            and <strong>Not-Spam</strong>.</p>

            <p>In contrast, you wouldn't put <strong>Spam</strong> in the
            <strong>Feelings</strong> vector because it doesn't belong to that list of categories.</p>

            <p>Please note that <strong>hundreds of documents</strong>
            need to be trained in each category before any ammount of accuracy is apparent.</p>



			</div>
		</td>
	</tr>
</table>



</div>

{include file=$r->xhtml_footer}