using MQTTnet.Client.Options;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ResourceServer.Extensions
{
    public class MQTTOptionBuilder: MqttClientOptionsBuilder
    {
        public IServiceProvider ServiceProvider { get; }

        public MQTTOptionBuilder(IServiceProvider serviceProvider)
        {
            ServiceProvider = serviceProvider;
        }
    }
}
