﻿using AgGateway.ADAPT.ApplicationDataModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AgGateway.ADAPT.Plugins
{
    internal class TreatmentZone
    {
        public List<DataVariable> Variables { get; set; }
        public string Name { get; set; }
    }
}