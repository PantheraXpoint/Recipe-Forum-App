using MediatR;
using ResourceServer.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace ResourceServer.Services.Implementation.MQTTReceiver
{
    public class TemperatureRequest: IRequest 
    {
        public int id { get; set; }
        public string name { get; set; }
        public string data { get; set; }
        public string unit { get; set; }
    }


    public class TemperatureReceiver : AsyncRequestHandler<TemperatureRequest>
    {
        private readonly IMQTTClientService mqttClient;
        public TemperatureReceiver(MQTTClientServiceProvider provider)
        {
            mqttClient = provider.MqttClientService;
        }

        protected override async Task Handle(TemperatureRequest request, CancellationToken cancellationToken)
        {
            Console.WriteLine("Temperature handler");
            await mqttClient.PublishAsync("0938795154/feeds/home", "OFF");
        }
    }
}
