using MediatR;
using ResourceServer.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace ResourceServer.Services.Implementation.MQTTReceiver
{
    public class GasRequest : IRequest
    {
        public int id { get; set; }
        public string name { get; set; }
        public string data { get; set; }
        public string unit { get; set; }
    }



    public class GasReceiver : AsyncRequestHandler<GasRequest>
    {

        private readonly IMQTTClientService mqttClient;
        public GasReceiver(MQTTClientServiceProvider provider)
        {
            mqttClient = provider.MqttClientService;
        }

        protected override Task Handle(GasRequest request, CancellationToken cancellationToken)
        {
            throw new NotImplementedException();
        }
    }
}
