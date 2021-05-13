using MediatR;
using Microsoft.Extensions.DependencyInjection;
using MQTTnet;
using MQTTnet.Client;
using MQTTnet.Client.Connecting;
using MQTTnet.Client.Disconnecting;
using MQTTnet.Client.Options;
using MQTTnet.Client.Subscribing;
using ResourceServer.Constants;
using ResourceServer.Services.Implementation.MQTTReceiver;
using ResourceServer.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using static ResourceServer.Startup;

namespace ResourceServer.Services.Implementation
{
    public class MQTTClientService: IMQTTClientService
    {
        private IMqttClient mqttClient;
        private IMqttClientOptions options;
        private IServiceProvider _serviceProvider;

        public MQTTClientService(IMqttClientOptions options , IServiceProvider serviceProvider)
        {
            _serviceProvider = serviceProvider;
            this.options = options;
            mqttClient = new MqttFactory().CreateMqttClient();
            ConfigureMqttClient();
        }

        private void ConfigureMqttClient()
        {
            mqttClient.ConnectedHandler = this;
            mqttClient.DisconnectedHandler = this;
            mqttClient.ApplicationMessageReceivedHandler = this;
        }



        public async Task HandleApplicationMessageReceivedAsync(MqttApplicationMessageReceivedEventArgs eventArgs)
        {
            // inject transient service in to singleton 
            using var scope = _serviceProvider.CreateScope();
            
            var _mediator = scope.ServiceProvider.GetRequiredService<IMediator>();
            switch (eventArgs.ApplicationMessage.Topic)
            {
                case "0938795154/feeds/gas":
                    await _mediator.Send(new GasRequest
                    {
                        data = System.Text.Encoding.UTF8.GetString(eventArgs.ApplicationMessage.Payload)
                    });
                    break;
                case "0938795154/feeds/temperature":
                    await _mediator.Send(new TemperatureRequest
                    {
                        data = System.Text.Encoding.UTF8.GetString(eventArgs.ApplicationMessage.Payload)
                    });
                    break;
                default:
                    throw new Exception("Unhandle message");
            }
        }

        public async Task HandleConnectedAsync(MqttClientConnectedEventArgs eventArgs)
        {
            System.Console.WriteLine("Connecting to adafruid server");
            
            foreach (var topic in AppSettingsProvider.MQTTClientSettings.SubcribeList)
            {
                await mqttClient.SubscribeAsync(topic);
            }
         
            Console.WriteLine("Success fully subscribe to home topic");
        }

        public async Task HandleDisconnectedAsync(MqttClientDisconnectedEventArgs eventArgs)
        {
            System.Console.WriteLine("Cant connect to server");
        }

        public async Task StartAsync(CancellationToken cancellationToken)
        {
            await mqttClient.ConnectAsync(options);
            if (!mqttClient.IsConnected)
            {
                await mqttClient.ReconnectAsync();
            }
        }

        public async Task StopAsync(CancellationToken cancellationToken)
        {
            if (cancellationToken.IsCancellationRequested)
            {
                var disconnectOption = new MqttClientDisconnectOptions
                {
                    ReasonCode = MqttClientDisconnectReason.NormalDisconnection,
                    ReasonString = "NormalDiconnection"
                };
                await mqttClient.DisconnectAsync(disconnectOption, cancellationToken);
            }
            await mqttClient.DisconnectAsync();
        }

        public async Task PublishAsync(string topic, string payload, bool retainFlag = true, int qos = 1)
            => await mqttClient.PublishAsync(new MqttApplicationMessageBuilder()
            .WithTopic(topic)
            .WithPayload(payload)
            .WithQualityOfServiceLevel((MQTTnet.Protocol.MqttQualityOfServiceLevel)qos)
            .WithRetainFlag(retainFlag)
            .Build());
    }
}
