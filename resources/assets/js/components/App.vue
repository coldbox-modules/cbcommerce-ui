<template>
    <div class="page-wrap" fluid>
        <nav-cart></nav-cart>

        <main role="main" class="col-sm-12">

            <router-view></router-view>

        </main>
    </div>
</template>

<script>
    import NavCart from "@cbCommerce/components/ui/nav-cart";
    export default{
        name  : "app",
        components : {
            NavCart
        }
    }
</script>