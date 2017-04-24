<template lang="pug">
    #root-element.ui.container
        .ui.action.input
            input(placeholder="lol", v-model="input")
            button.ui.button(@click="push") Push
        .ui.list
            .item(v-for="msg in messages") {{msg.message}}
</template>

<script>
    import socket from './socket'

    export default {
        name: 'app',
        data() {
            return {
                input: '',
                messages: [],
                channel: null
            }
        },
        mounted() {
            this.channel = socket.channel("room:lobby", {})
            this.channel.join()
                .receive("ok", resp => { console.log("Joined successfully", resp) })
                .receive("error", resp => { console.log("Unable to join", resp) })
            this.channel.on('shout', payload => this.messages.push(payload))
        },
        methods: {
            push() {
                this.channel.push('shout', {message: this.input})
                this.input = ''
            }
        }
    }
</script>