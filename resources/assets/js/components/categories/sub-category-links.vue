<template>

    <div class="col-md-12 col-lg-6 subCatLink">
        <a :href="this.catLink">{{ this.catName }}</a>
    </div>

</template>

<script>

export default {
    props: [
        'subCat'
    ],

    created: function(){
        this.parseContent();
    },

    data() {
        return {
            isLoading: true,
            catName  : null,
            catLink  : null
        }
    },

    mounted() {},

    destroyed() {},

    methods: {
        parseContent: function(){
            var self          = this;
            var parsedContent = self.subCat;
            self.catName      = parsedContent.name;
            self.catLink      = parsedContent.link;
            self.isLoading    = false;
        }
    },

    computed: {}
}
</script>